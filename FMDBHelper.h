//
//  FMDBHelper.h
//  FMDB
//
//  Created by zhf on 16/4/26.
//  Copyright © 2016年 zhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHelper : NSObject

+ (FMDBHelper *)sharedFMDBHelper;
#pragma mark - 根据名称创建沙盒路径用来保存数据库文件
- (void)createDBWithName:(NSString *)dbName;
#pragma mark - 无返回结果集的操作 - 建表、添加、删除、更新（修改）、销毁表
- (BOOL)notResultSetWithSql:(NSString *)sql;
#pragma mark - 有返回结果集的操作 - 查询
- (NSArray *)qureyWithSql:(NSString *)sql;

@end
