//
//  ProcessFlowModel.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 26/02/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessFlowModel.h"

@implementation ProcessFlowModel

+ (ProcessFlowModel*) objectFromDict:(NSDictionary*)dict {
    
    ProcessFlowModel *model = [ProcessFlowModel new];
    model.processFlowId = dict[@"process_ctrl_id_alias"];
    model.processFlowAlias = dict[@"stepid"];
    model.status = dict[@"status"];
    
    return model;
}

@end
