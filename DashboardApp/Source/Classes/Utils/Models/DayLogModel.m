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
    model.time = data[@"actualtime"];

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
    
    if (_time != nil) {
        log[@"actualtime"] = _time;
    }
    
    if (_dayLogID != 0)
        log[@"id"] = @(_dayLogID);
    
    return log;
}

+ (NSArray *)daysFromResponse:(NSArray *)response forRun:(Run*)run {
    
    NSMutableArray *daysArr = [NSMutableArray array];
    NSArray *days = [response firstObject][@"processes"];
    days = [days sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:false]]];
    for (int i=0; i<days.count; i++) {
        
        NSDictionary *dict = days[i];
        if ([dict[@"datetime"] isEqualToString:@"0000-00-00 00:00:00"] == true)
            continue;
        
        DayLogModel *d = [DayLogModel objFromData:dict];
        d.runId = [run getRunId];
        if ([self dayLogAlreadyExists:d inArr:daysArr] == false)
            [daysArr addObject:d];
    }
    [daysArr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:true]]];
    return daysArr;
}

+ (BOOL) dayLogAlreadyExists:(DayLogModel*)log inArr:(NSArray*)arr {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    for (DayLogModel *d in arr) {
        if ([c isDate:log.date inSameDayAsDate:d.date] && [d.processNo isEqualToString:log.processNo] && [d.person isEqualToString:log.person])
            return true;
    }
    
    return false;
}

@end
