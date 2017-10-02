//
//  DataManager.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Run.h"
#import "Defines.h"
#import "ServerManager.h"

#define __DataManager [DataManager sharedInstance]

@protocol DataManagerProtocol;
@interface DataManager : NSObject<ServerProtocol> {
    int currentRunId;
    NSString *currentJobId;
    NSString *currentProcessId;
    NSMutableArray *runsArray;
    NSMutableArray *processArray;
    NSMutableArray *parseRuns;
    NSMutableArray *rmaArray;
    NSMutableArray *demandsArray;
    NSMutableArray *partsTransferArray;
    NSMutableArray *feedbacksArray;
    NSMutableArray *tasksArray;
    NSMutableArray *thisWeekRunsArray;
    NSMutableArray *nextWeekRunsArray;
    NSMutableArray *thisWeekOperationsArray;
    NSMutableArray *commonProcessesArray;
    NSMutableArray *editedProcessesArray;
    NSMutableArray *productsArray;
}

+ (id) sharedInstance;
__pds(DataManagerProtocol);
- (void)setRunsList:(NSMutableArray*)runsArray;
- (void)setProcessList:(NSMutableArray*)processesArray forRunId:(int)runId;
- (void)setWorkInstructions:(NSMutableArray*)instructions forProcessId:(NSString*)processId;
- (void)setRMAList:(NSMutableArray*)rmaArray_;
- (NSMutableArray*)getRMAList;
- (void)setDemandList:(NSMutableArray*)demandsArray_;
- (NSMutableArray*)getDemandList;
- (void)setPartsTransferList:(NSMutableArray*)partsTransferArray_;
- (NSMutableArray*)getFeedbackList;
- (void)setFeedbackList:(NSMutableArray*)feedbacksArray_;
- (NSMutableArray*)getPartsTransferList;
- (void)setChecklistArray:(NSMutableArray*)checklist;
- (void)syncDatabase;
- (void)syncRuns;
- (int)getCurrentRunId;
- (NSString*)getCurrentJobId;
- (NSString*)getCurrentProcessId;
- (NSMutableArray*)getRuns;
- (Run*)getRunWithId:(int)runId;
- (NSMutableArray*)getRunsWithProductId:(NSString*)productId;
- (NSMutableArray*)getJobsForRunId:(int)runId;
- (NSMutableArray*)getProcesses;
- (NSMutableArray*)getWorkInstructionsForProcessId:(NSString*)processId;
- (NSMutableArray*)getChecklistArray;
- (void)saveParseRuns:(NSMutableArray*)parseRuns_;
- (NSMutableArray*)getParseRuns;
- (NSMutableDictionary*)getParseRunForId:(int)runId;
- (void)syncRun:(int)runId;
- (void)syncRunProcesses:(int)runId;
- (void)setTaskList:(NSMutableArray*)taskArray_;
- (NSMutableArray*)getTaskList;
- (void)setThisWeekRuns:(NSMutableArray*)thisWeekRuns;
- (NSMutableArray*)getThisWeekRuns;
- (void)setNextWeekRuns:(NSMutableArray*)nextWeekRuns;
- (NSMutableArray*)getNextWeekRuns;
- (void)setThisWeekOperations:(NSMutableArray*)thisWeekOperations;
- (NSMutableArray*)getThisWeekOperations;
- (NSMutableArray*)getInProgressRuns;
- (void)setCommonProcesses:(NSMutableArray*)commonProcessesArray_;
- (NSMutableArray*)getCommonProcesses;
- (void)updateProcessAtIndex:(int)index process:(NSMutableDictionary*)processData;
- (void)syncCommonProcesses;
- (void)syncProcesses:(NSMutableArray*)processesArray withProcessData:(NSMutableDictionary*)processData;
- (void)syncRunProcesses:(NSMutableArray*)processesArray withProcessData:(NSMutableDictionary*)processData;
- (void)updateRunProcesses:(NSMutableArray*)processesArray withProcessData:(NSMutableDictionary*)processData;
- (void)setProductsArray:(NSMutableArray*)productsArray_;
- (NSMutableArray*)getProductsArray;
- (NSMutableDictionary*)getProcessForNo:(NSString*)processNo;
- (NSString*)getTimeForProcessNo:(NSString*)processNo;
@end

@protocol DataManagerProtocol <NSObject>
- (void)receivedServerResponse;
- (void)receivedSuccessResponse;
- (void)receivedErrorResponse;
@end
