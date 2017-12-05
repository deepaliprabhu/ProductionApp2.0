//
//  PartAuditModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartAuditModel.h"

@implementation PartAuditModel

+ (PartAuditModel*) objFrom:(NSArray*)a
{
    PartAuditModel *p = [PartAuditModel new];
    NSMutableArray *actions = [NSMutableArray array];
    
    for (NSDictionary *d in a) {
        ActionModel *m = [ActionModel objFrom:d];
        [actions addObject:m];
    }
    
    NSArray *descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]];
    [actions sortUsingDescriptors:descriptors];
    p.actions = [NSArray arrayWithArray:actions];
    
    return p;
}

- (ActionModel*) lastMasonAction {
 
    for (int i=0; i<_actions.count; i++) {
        
        ActionModel *m = _actions[i];
        if ([m.location isEqualToString:@"MASON"]) {
            return m;
        }
    }
    
    return nil;
}

- (ActionModel*) lastPuneAction {
 
    for (int i=0; i<_actions.count; i++) {
        
        ActionModel *m = _actions[i];
        if ([m.location isEqualToString:@"PUNE"]) {
            return m;
        }
    }
    
    return nil;
}

- (void) computeData {
    
    if (_days != nil)
        return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (ActionModel *a in _actions) {
        
        if (dict[a.date] == nil) {
            [dict setObject:@[a] forKey:a.date];
        } else {
            
            NSMutableArray *arr = [NSMutableArray arrayWithArray:dict[a.date]];
            [arr addObject:a];
            [dict setObject:arr forKey:a.date];
        }
    }
    
    NSMutableArray *days = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSDate *key, NSArray *actions, BOOL * _Nonnull stop) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"date"] = key;
        dict[@"actions"] = actions;
        
        int reconcile = 0;
        int run = 0;
        NSNumber *pune = nil;
        NSNumber *mason = nil;
        
        NSMutableArray *alreadyParsedLocations = [NSMutableArray array];
        for (ActionModel *a in actions) {
            
            if ([alreadyParsedLocations containsObject:a.location])
                continue;
            
            [alreadyParsedLocations addObject:a.location];
            if ([a.location isEqualToString:@"MASON"])
                mason = @([a.qty intValue]);
            else
                pune = @([pune intValue] + [a.qty intValue]);
            
            if ([a.mode isEqualToString:@"PRODUCTION_PARTS"]) {
                run += ([a.prevQTY intValue] - [a.qty intValue]);
            } else if ([a.mode isEqualToString:@"RECONCILE_PARTS"]) {
                reconcile += ([a.prevQTY intValue] - [a.qty intValue]);
            }
        }
        
        if (reconcile > 0)
            dict[@"reco"] = @(reconcile);
        if (run > 0)
            dict[@"run"] = @(run);
        dict[@"mason"] = mason;
        dict[@"pune"] = pune;
        
        if (reconcile + run > _maxNegative)
            _maxNegative = reconcile + run;
        if ([mason intValue] + [pune intValue] > _maxPositive)
            _maxPositive = [mason intValue] + [pune intValue];
        
        [days addObject:dict];
    }];
    
    [days sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1[@"date"] compare:obj2[@"date"]];
    }];
    
    for (int i=0; i<days.count;i++) {

        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:days[i]];
        BOOL found = false;
        if (dict[@"mason"] == nil)
        {
            for (int j=i-1;j>=0; j--) {
                NSDictionary *dictj = days[j];
                if (dictj[@"mason"] != nil) {
                    dict[@"mason"] = dictj[@"mason"];
                    found = true;
                    break;
                }
            }
            
        }
        
        if (dict[@"pune"] == nil)
        {
            for (int j=i-1;j>=0; j--) {
                NSDictionary *dictj = days[j];
                if (dictj[@"pune"] != nil) {
                    dict[@"pune"] = dictj[@"pune"];
                    found = true;
                    break;
                }
            }
            
        }
        
        if ([dict[@"mason"] intValue] + [dict[@"pune"] intValue] > _maxPositive)
            _maxPositive = [dict[@"mason"] intValue] + [dict[@"pune"] intValue];
        
        if (found == true)
            [days replaceObjectAtIndex:i withObject:dict];
    }
    
    _days = [NSArray arrayWithArray:days];
}

@end
