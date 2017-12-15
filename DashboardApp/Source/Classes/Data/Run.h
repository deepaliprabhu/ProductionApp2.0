//
//  Run.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "Product.h"
//#import "Process.h"


@interface Run : NSObject {
    NSMutableArray *runJobs;
    NSMutableArray *runProcesses;
    NSMutableArray *runDefects;
    NSMutableArray *runFeedbacks;
    NSMutableArray *runPartsShort;
    NSMutableArray *runFlowProcesses;
    NSMutableDictionary *runData;
    
    UIColor *runColor;
}
@property NSInteger runId;
@property NSInteger completionStatus;
@property NSInteger quantity;
@property NSInteger ready;
@property NSInteger inProcess;
@property NSInteger shipped;
@property NSInteger reject;
@property NSInteger rework;
@property NSInteger productId;
@property NSInteger priority;
@property NSInteger sequence;
@property NSInteger category;
@property NSInteger order;
@property NSString *runType;
@property NSString *productName;
@property NSString *productNumber;
@property NSString *vendorName;
@property NSString *requestDate;
@property NSString *runDate;
@property NSString *status;
@property NSString *shipping;
@property NSString *detail;
@property BOOL activated;
@property BOOL isLocked;


- (void)updateRunStatus:(NSString*)statusString;
- (void)updateRunStatus:(NSString*)statusString withQty:(int)quantity;
- (void)setRunData:(NSDictionary*)runData;
- (void)updateRunData:(NSDictionary*)runData;
- (NSMutableDictionary*)getRunData;
- (void)setRunJobs:(NSMutableArray*)jobsArray;
- (void)setRunProcesses:(NSMutableArray*)prcessesArray;
- (void)setRunDefects:(NSMutableArray*)defectsArray;
- (void)setJobDetail:(NSMutableDictionary*)jobDetail ForJobId:(NSString*)jobId;
- (void)setSequenceNum:(int)sequence_;
- (NSMutableArray*)getRunJobs;
- (NSMutableArray*)getRunJobsForType:(int)type;
- (NSMutableArray*)getRunProcesses;
- (int)getRunId;
- (NSString*) getFullTitle;
- (int)getProductId;
- (NSString*)getProductNumber;
- (int)getQuantity;
- (int)getReject;
- (int)getRework;
- (int)getPriority;
- (int)getBatchCount;
- (NSString*)getRunType;
- (BOOL)isActivated;
- (NSString*)getProductName;
- (NSString*)getVendorName;
- (NSString*)getRequestDate;
- (NSString*)getRunDate;
- (NSString*)getStatus;
- (NSString*)getDescription;
- (void)setCategory:(int)category_;
- (int)getCategory;
- (NSMutableArray*)getRunFeedbacks;
- (void)addRunFeedback:(NSMutableDictionary*)feedbackData;
- (NSMutableArray*)getRunPartsShort;
- (void)setRunPartsShort:(NSMutableArray*)partsShortArray;
- (void)setRunCompletion:(int)value;
- (int)getRunCompletion;
- (void)setRunColor:(UIColor*)color;
- (UIColor*)getRunColor;
- (void)setRunFlowProcesses:(NSMutableArray*)flowProcessesArray;
- (NSMutableArray*)getRunFlowProcesses;
- (void)updateRunStats:(NSDictionary*)statsData;
@end
