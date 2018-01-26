//
//  ServerManager.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"
#import "Defines.h"

#define __ServerManager [ServerManager sharedInstance]

@protocol ServerProtocol;
@interface ServerManager : NSObject <ConnectionProtocol> {
    ConnectionManager *connectionManager;
}
+ (id) sharedInstance;
__pds(ServerProtocol);
- (void)loginUser;
- (void)getRunsList;
- (void)getJobsListForRunId:(int)runId;
- (void)getJobsDetailsForJobId:(NSString*)jobId;
- (void)setJobDetailsWithJsonString:(NSString*)jsonString;
- (void)updateRunsWithJsonString:(NSString*)jsonString;
- (void)updateRunProcesses:(int)runId withJsonString:(NSString*)jsonString;
- (void)updateRun:(int)runId withJsonString:(NSString*)jsonString;
- (void)getProcessListForRunId:(int)runId;
- (void)getWorkInstructionsList;
- (void)getChecklistList;
- (void)getDefects;
- (void)getRMAs;
- (void)getDemands;
- (void)getFeedbacks;
- (void)getPartsTransfer;
//test calls for offline usage
- (void)getRunsListTest;
- (void)getJobsListTest;
- (void)getProcessList;
- (void)updateCommonProcessesWithJsonString:(NSString*)jsonString;
- (void)addProcessFlowWithJsonString:(NSString*)jsonString;
- (void)updateProcessFlowWithJsonString:(NSString*)jsonString;
- (void)addRunProcessFlowWithJsonString:(NSString*)jsonString;
- (void)updateRunProcessFlowWithJsonString:(NSString*)jsonString;
- (void)getProcessesForProductNumber:(NSString*)productNumber;
- (void)getProductList;
@end

@protocol ServerProtocol <NSObject>
- (void)receivedServerResponse;
- (void)receivedSuccessResponse;
- (void)receivedErrorResponse;
@end
