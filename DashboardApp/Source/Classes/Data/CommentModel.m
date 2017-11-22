//
//  CommentModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (CommentModel*) objectFrom:(NSDictionary*)d
{
    CommentModel *m = [CommentModel new];
    return m;
}

@end
