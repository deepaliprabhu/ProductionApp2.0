//
//  ProcessModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProcessModel.h"

@implementation ProcessModel

+ (ProcessModel*) objectFromProcess:(NSDictionary*)pr andCommon:(NSDictionary*)common {

    ProcessModel *model = [ProcessModel new];
    model.processNo = pr[@"processno"];
    model.stepId = pr[@"stepid"];
    model.processId = pr[@"id"];
    model.person = pr[@"operator"];
    model.qtyGood = pr[@"qtyGood"];
    model.qtyReject = pr[@"qtyReject"];
    model.qtyRework = pr[@"qtyRework"];
    model.qtyTarget = pr[@"qtyTarget"];
    model.runFlowId = pr[@"run_flow_id"];
    model.dateAssigned = pr[@"dateAssigned"];
    model.dateCompleted = pr[@"dateCompleted"];
    model.processingTime = common[@"time"];
    model.processName = common[@"processname"];
    model.instructions = common[@"workinstructions"];
    model.status = pr[@"status"];
    
    return model;
}

- (BOOL) isPassiveTests {
    return [_processName isEqualToString:@"Passive Test"];
}

- (BOOL) isActiveTests {
    return [_processName isEqualToString:@"Active Test"];
}

- (BOOL) isPreMoldingTests {
    return [_processName isEqualToString:@"Pre Mold Probe Testing"];
}

- (BOOL) isPostMoldingTests {
    return [_processName isEqualToString:@"Post molding Probe Testing"];
}

- (BOOL) isPackaging {
    return [_processName hasPrefix:@"Packaging"];
}

- (BOOL) isShipping {
    return [_processName hasPrefix:@"Shipping"];
}

@end
