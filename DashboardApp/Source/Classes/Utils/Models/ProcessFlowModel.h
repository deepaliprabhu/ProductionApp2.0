//
//  ProcessFlowModel.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 26/02/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessFlowModel : NSObject

@property (nonatomic, strong) NSString *processFlowId;
@property (nonatomic, strong) NSString *processFlowAlias;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *comments;


+ (ProcessFlowModel*) objectFromDict:(NSDictionary*)dict;

@end
