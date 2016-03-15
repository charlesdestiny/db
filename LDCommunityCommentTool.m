//
//  LDCommunityCommentTool.m
//  ZXLoveDiary
//
//  Created by  on 15/11/4.
//  Copyright © 2015年 zx. All rights reserved.
//  评论工具类,缓存微博数据

#import "LDCommunityCommentTool.h"
#import "FMDB.h"

@implementation LDCommunityCommentTool
static FMDatabase *_db;
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"comments.sqlite"];
//    NSString *path = [@"/Users/qcy/Desktop/123" stringByAppendingPathComponent:@"comments.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    
    [_db open];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_comment (id interger PRIMARY KEY,comment blob NOT NULL,idstr text NOT NULL,to_post_id text NOT NULL);"];
    
}

+ (NSArray *)commentsWithParams:(NSDictionary *)params
{
    NSString *sql= nil;
    if (params[@"id_gt"]) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_comment WHERE idstr<%@ AND to_post_id = %@ ORDER BY idstr ASC LIMIT %@",params[@"id_gt"],params[@"to_post_id"],params[@"limit"]];
    }else if(params[@"with_top"]){
        sql = [NSString stringWithFormat:@"SELECT * FROM t_comment WHERE to_post_id = %@ ORDER BY idstr ASC LIMIT %@",params[@"to_post_id"],params[@"limit"]];
    }

    
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *comments = [NSMutableArray array];
    while (set.next) {
        NSData *commentData =  [set objectForColumnName:@"comment"];
        NSDictionary *comment = [NSKeyedUnarchiver unarchiveObjectWithData:commentData];
        [comments addObject:comment];
    }
    return comments;
}

+ (void)saveComments:(NSArray *)comments withToPostId:(NSInteger)toPostId
{
    for (NSDictionary *comment in comments) {
      BOOL ret = [_db executeUpdateWithFormat:@"DELETE FROM t_comment WHERE idstr = %@",comment[@"id"]];
        ZXLog(@"%i",ret);
       NSData *commentData = [NSKeyedArchiver archivedDataWithRootObject:comment];
        [_db executeUpdateWithFormat:@"INSERT INTO t_comment(comment,idstr,to_post_id)VALUES (%@,%@,%d);",commentData,comment[@"id"],toPostId];
    }
}

@end
