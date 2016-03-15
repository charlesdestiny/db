//
//  LDCommunityCommentTool.h
//  ZXLoveDiary
//
//  Created by  on 15/11/4.
//  Copyright © 2015年 zx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDCommunityCommentTool : NSObject

+ (NSArray *)commentsWithParams:(NSDictionary *)params;

+ (void)saveComments:(NSArray *)comments withToPostId:(NSInteger )toPostId;

@end
