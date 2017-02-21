# FMDBTools
基于FMDB简易封装的工具类
- 使用时直接拖入工程，确保工程已经集成了FMDB
- 导入头文件```#import "FMDBHelper.h"```
- 以下为示例 ：
```
//创建数据库文件，并且建表
    FMDBHelper *dbHelper = [FMDBHelper sharedFMDBHelper];
    //创建数据库文件
    [dbHelper createDBWithName:@"moment"];
    //创建保存文章的表
    BOOL isSuccess = [dbHelper notResultSetWithSql:@"create table if not exists article(userid PRIMARY KEY text,contentid text,title text,content text,coverimg text)"];
    if (!isSuccess) {
        NSLog(@"创建收藏文章表失败");
    }
    //创建下载的列表
    BOOL isDownload = [dbHelper notResultSetWithSql:@"create table if not exists downloadList(soundid text primary key,title text,content blob)"];
    if (!isDownload) {
        NSLog(@"创建下载列表失败");
    }
```
```
//通过搜索条件查询数据库返回所查数据
self.dataSource = [[FMDBHelper sharedFMDBHelper] qureyWithSql:
                       [NSString stringWithFormat:
                        @"select *from article where userid = '%@'",[LoginUserInfoModel sharedUserInfo].uid]];
```
