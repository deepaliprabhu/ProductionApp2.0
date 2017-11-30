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
        int pune = 0;
        int mason = 0;
        for (ActionModel *a in actions) {
            
            if ([a.location isEqualToString:@"MASON"])
                mason = [a.qty intValue];
            else
                pune += [a.qty intValue];
            
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
        if (mason > 0)
            dict[@"mason"] = @(mason);
        if (pune > 0)
            dict[@"pune"] = @(pune);
        
        if (reconcile + run > _maxNegative)
            _maxNegative = reconcile + run;
        if (mason + pune > _maxPositive)
            _maxPositive = mason + pune;
        
        [days addObject:dict];
    }];
    
    [days sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1[@"date"] compare:obj2[@"date"]];
    }];
    
    _days = [NSArray arrayWithArray:days];
}

@end
