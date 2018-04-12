//
//  ProcessModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessModel : NSObject

@property (nonatomic, strong) NSString *processNo;
@property (nonatomic, strong) NSString *stepId;
@property (nonatomic, strong) NSString *processId;
@property (nonatomic, strong) NSString *person;
@property (nonatomic, strong) NSString *qtyGood;
@property (nonatomic, strong) NSString *qtyReject;
@property (nonatomic, strong) NSString *qtyRework;
@property (nonatomic, strong) NSString *qtyTarget;
@property (nonatomic, strong) NSString *runFlowId;
@property (nonatomic, strong) NSString *dateAssigned;
@property (nonatomic, strong) NSString *dateCompleted;
@property (nonatomic, strong) NSString *processingTime;
@property (nonatomic, strong) NSString *processName;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, unsafe_unretained) int processed;
@property (nonatomic, unsafe_unretained) int rejected;

+ (ProcessModel*) objectFromProcess:(NSDictionary*)pr andCommon:(NSDictionary*)common;

- (BOOL) isPassiveTests;
- (BOOL) isActiveTests;
- (BOOL) isPreMoldingTests;
- (BOOL) isPostMoldingTests;
- (BOOL) isPackaging;
- (BOOL) isShipping;

@end
