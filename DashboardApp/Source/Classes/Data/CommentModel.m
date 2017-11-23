//
//  CommentModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "CommentModel.h"

static NSDateFormatter *_formatter1 = nil;
static NSDateFormatter *_formatter2 = nil;

@implementation CommentModel

+ (CommentModel*) objectFrom:(NSDictionary*)d
{
    CommentModel *m = [CommentModel new];
    m.author = d[@"COMMENTS_BY"];
    m.message = d[@"DESCRIPTION"];
    m.date = [_formatter1 dateFromString:d[@"DATETIME"]];
    return m;
}

- (NSString*) dateString
{
    return [_formatter2 stringFromDate:_date];
}

+ (void) initialize
{
    [super initialize];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter1 = [[NSDateFormatter alloc] init];
        _formatter1.dateFormat = @"dd-MMM-yyyy - HH:mm";
        
        _formatter2 = [[NSDateFormatter alloc] init];
        _formatter2.dateFormat = @"dd MMM - HH:mm";
    });
}

@end
