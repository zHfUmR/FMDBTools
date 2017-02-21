//
//  FMDBHelper.m
//  FMDB
//
//  Created by zhf on 16/4/26.
//  Copyright © 2016年 zhf. All rights reserved.
//

#import "FMDBHelper.h"
#import <FMDB/FMDB.h>
@interface FMDBHelper ()

@property (nonatomic,retain) NSString *fileName;//数据库文件的路径

@property (nonatomic,retain) FMDatabase *dataBase;//数据库对象

@end



@implementation FMDBHelper
//单例
+ (FMDBHelper *)sharedFMDBHelper{
    static FMDBHelper *helper = nil;
    //线程锁的方法
//    @synchronized(self) {
//        if (helper == nil) {
//            helper = [[FMDBHelper alloc] init];
//        }
//    }
    //GCD的方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FMDBHelper alloc] init];
    });
    return helper;
}
//让用户自己命名表名
- (void)createDBWithName:(NSString *)dbName{
    
    if (0 == dbName.length) {
        //是防止用户直接传进来为nil或者空字符串
        self.fileName = @"";//FMDB会创建一个临时的数据库
    }else{
        //判断用户是否为文件添加后缀名
        if (![dbName hasSuffix:@".sqlite"]) {
            self.fileName = [dbName stringByAppendingString:@".sqlite"];
        }else{
            self.fileName = dbName;
        }
    }
}
//根据名称创建沙盒路径用来保存数据库文件
- (NSString *)dbPath{
    if (self.fileName.length) {
        //获取沙盒路径
        NSString *homePath = NSHomeDirectory();
        NSString *savePath = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.fileName]];
        NSLog(@"----%@",savePath);
        return savePath;
    }else{
        return @"";
    }
}
//打开或者创建数据库
- (BOOL)openOrCreateDB{
    if ([self.dataBase open]) {
        NSLog(@"数据库打开成功");
        return YES;
    }else{
        NSLog(@"数据库打开失败");
        return NO;
    }
}
//关闭数据库的方法
- (void)closeDB{
    BOOL isClose = [self.dataBase close];
    if (isClose) {
        NSLog(@"关闭成功");
    }else{
        NSLog(@"关闭失败");
    }
}
//无返回结果集的操作
- (BOOL)notResultSetWithSql:(NSString *)sql{
    //打开数据库
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        BOOL isUpdate = [self.dataBase executeUpdate:sql];
        [self closeDB];
        return isUpdate;
    }else{
        return NO;
    }
}
//通用的查询方法
- (NSArray *)qureyWithSql:(NSString *)sql{
    //打开数据库
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        //得到多有记录的结果集
        FMResultSet *resultSet = [self.dataBase executeQuery:sql];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        //遍历结果集，取出每一条记录，转换为字典类型，并且存储到可变数组中 - 未知表的字段数，字段名，字段类型
        while ([resultSet next]) {
            //直接将一条记录转换为字典类型
            NSDictionary *dic = [resultSet resultDictionary];
            [resultArray addObject:dic];
        }
        //释放结果集
        [resultSet close];
        //关闭数据库
        [self closeDB];
        return resultArray;
    }else{
        NSLog(@"打开数据库失败");
        return nil;
    }
}
//创建数据库对象
- (FMDatabase *)dataBase{
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:[self dbPath]];
    }
    return _dataBase;
}


@end
