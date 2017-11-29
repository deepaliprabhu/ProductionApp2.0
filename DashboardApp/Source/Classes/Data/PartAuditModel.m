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

@end
