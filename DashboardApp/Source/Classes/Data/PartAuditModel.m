//
//  PartAuditModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartAuditModel.h"
#import "ActionModel.h"

@implementation PartAuditModel

+ (PartAuditModel*) objFrom:(NSArray*)a
{
    PartAuditModel *p = [PartAuditModel new];
    NSMutableArray *actions = [NSMutableArray array];
    for (NSDictionary *d in a) {
        ActionModel *m = [ActionModel objFrom:d];
        [actions addObject:m];
    }
    p.actions = [NSArray arrayWithArray:actions];
    
    return p;
}

@end
