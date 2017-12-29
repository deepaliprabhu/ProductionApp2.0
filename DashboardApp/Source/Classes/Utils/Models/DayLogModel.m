//
//  DayLogModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DayLogModel.h"

static NSDateFormatter *_formatter = nil;

@implementation DayLogModel

+ (DayLogModel*) objFromData:(NSDictionary*)data {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    
    DayLogModel *model = [DayLogModel new];
    model.data = data;
    model.reject = [data[@"qtyReject"] intValue];
    model.rework = [data[@"qtyRework"] intValue];
    model.good = [data[@"qtyGood"] intValue];
    model.target = [data[@"qtyTarget"] intValue];
    model.processId = data[@"stepid"];
    model.dateAssigned = data[@"dateAssigned"];
    model.dateCompleted = data[@"dateCompleted"];
    model.person = data[@"operator"];

    if ([data[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == false) {
        model.date = [_formatter dateFromString:data[@"datetime"]];
    }
    
    return model;
}

- (int) totalWork {    
    return _reject + _rework + _good;
}

@end
