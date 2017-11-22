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
    NSMutableArray *s2 = [NSMutableArray array];
    NSMutableArray *p2 = [NSMutableArray array];
    NSMutableArray *pune = [NSMutableArray array];
    NSMutableArray *mason = [NSMutableArray array];
    
    for (NSDictionary *d in a) {
        ActionModel *m = [ActionModel objFrom:d];
        if ([m.location isEqualToString:@"S2"])
            [s2 addObject:m];
        else if ([m.location isEqualToString:@"PUNE"])
            [pune addObject:m];
        else if ([m.location isEqualToString:@"MASON"])
            [mason addObject:m];
        else if ([m.location isEqualToString:@"P2"])
            [p2 addObject:m];
    }
    
    NSArray *descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]];
    [s2 sortUsingDescriptors:descriptors];
    [p2 sortUsingDescriptors:descriptors];
    [pune sortUsingDescriptors:descriptors];
    [mason sortUsingDescriptors:descriptors];
    
    p.s2Actions = [NSArray arrayWithArray:s2];
    p.p2Actions = [NSArray arrayWithArray:s2];
    p.puneActions = [NSArray arrayWithArray:s2];
    p.masonActions = [NSArray arrayWithArray:s2];
    
    return p;
}

@end
