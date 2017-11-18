//
//  ActionModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ActionModel.h"

static NSDateFormatter *_formatter = nil;

@implementation ActionModel

+ (ActionModel*) objFrom:(NSDictionary*)d
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    });
    
    ActionModel *a = [ActionModel new];
    a.action = d[@"ACTION"];
    a.date = [_formatter dateFromString:d[@"DATETIME"]];
    a.location = d[@"LOCATION"];
    a.mode = d[@"MODE"];
    a.qty = d[@"NEWQTY"];
    a.process = d[@"PROCESS_REF"];
    
    return a;
}

@end
