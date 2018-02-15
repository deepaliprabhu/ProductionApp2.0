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
    model.dayLogID = [data[@"id"] intValue];
    model.data = data;
    model.rework = [data[@"qtyRework"] intValue];
    model.good = [data[@"qtyGood"] intValue];
    model.target = [data[@"qtyTarget"] intValue];
//    model.reject = [data[@"qtyReject"] intValue];
    model.reject = model.target - model.good - model.rework;
    model.goal = [data[@"qtyGoal"] intValue];
    model.processNo = data[@"processno"];
    model.person = data[@"operator"];
    model.comments = data[@"comments"];

    if ([data[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == false) {
        model.date = [_formatter dateFromString:data[@"datetime"]];
    }
    
    return model;
}

- (int) totalWork {    
    return _reject + _rework + _good;
}

- (NSDictionary *)params {
    
    NSMutableDictionary *log = [NSMutableDictionary dictionary];
//    log[@"stepid"] = _processId;
    log[@"processno"] = _processNo;
    log[@"operator"] = _person;
    log[@"comments"] = _comments;
//    log[@"status"] = @"tmp";
    log[@"qtyTarget"] = [NSString stringWithFormat:@"%d", _target];
    log[@"qtyGood"] = [NSString stringWithFormat:@"%d", _good];
    log[@"qtyRework"] = [NSString stringWithFormat:@"%d", _rework];
    log[@"qtyReject"] = [NSString stringWithFormat:@"%d", _reject];
    log[@"qtyGoal"] = [NSString stringWithFormat:@"%d", _goal];
    log[@"datetime"] = [_formatter stringFromDate:_date];
    
    if (_dayLogID != 0)
        log[@"id"] = @(_dayLogID);
    
    return log;
}

@end
