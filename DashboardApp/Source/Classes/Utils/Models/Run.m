//
//  Run.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Run.h"


@implementation Run {

}

- (void)setRunData:(NSDictionary*)runData_ {
    
    runData = [runData_ mutableCopy];
    _order = [[runData objectForKey:@"Order"] intValue];
    if (_order == 0)
        _order = INT_MAX;
    _runId = [[runData objectForKey:@"Run"] intValue];
    _sequence = [[runData objectForKey:@"Sequence"] intValue];
    _quantity = [[runData objectForKey:@"Qty"] intValue];
    _requestDate = [runData objectForKey:@"REQUESTDATE"];
    _runDate = [runData objectForKey:@"Updated"];
    _vendorName = [runData objectForKey:@"VENDOR_ID"];
    _inProcess = [[runData objectForKey:@"Inprocess"] intValue];
    _ready = [[runData objectForKey:@"Ready"] intValue];
    _shipped = [[runData objectForKey:@"Shipped"] intValue];
    _rework = [[runData objectForKey:@"Rework"] intValue];
    _reject = [[runData objectForKey:@"Reject"] intValue];
    _status = [runData objectForKey:@"Status"];
    _isLocked = [_status isEqualToString:@"LOCKED"];
    _productId = [[runData objectForKey:@"PRODUCT_REV_ID"] intValue];
    runJobs = [[NSMutableArray alloc] init];
    _productName = [runData objectForKey:@"Product"];
    _productNumber = [runData objectForKey:@"Product ID"];
    _runType = [runData objectForKey:@"Run Type"];
    _vendorName = [runData objectForKey:@"Vendor_name"];
    _detail = [runData objectForKey:@"description"];
    _shipping = [runData objectForKey:@"Shipping"];
    _activated = [[runData objectForKey:@"JOBS"] boolValue];
    _priority = 0;
    //_sequence = 0;
    if ([runData[@"Category"] isEqualToString:@"PCB"]) {
        _category = 0;
    }
    else {
        _category = 1;
    }
    NSString *priorityString = (NSString*)[runData objectForKey:@"Priority"];
    if ([priorityString isEqualToString:@"High"]) {
        _priority = 2;
    }
    else if ([priorityString isEqualToString:@"Medium"]) {
        _priority = 1;
    }
    runDefects = [[NSMutableArray alloc] init];
    runProcesses = [[NSMutableArray alloc] init];
    runFeedbacks = [[NSMutableArray alloc] init];

}

- (void)updateRunStatus:(NSString*)statusString{
    _status = statusString;
    [runData setValue:_status forKey:@"Status"];
}

- (void)updateRunStatus:(NSString*)statusString withQty:(int)quantity{
    _status = statusString;
    _inProcess = [NSString stringWithFormat:@"%d",quantity];
    [runData setValue:_status forKey:@"Status"];
    [runData setValue:[NSString stringWithFormat:@"%d",quantity] forKey:@"Inprocess"];
}

- (void)updateRunData:(NSDictionary*)runData_ {
    _inProcess = [[runData_ objectForKey:@"InProcess"] intValue];
    _ready = [[runData_ objectForKey:@"Ready"] intValue];
    _shipped = [[runData_ objectForKey:@"Shipped"] intValue];
    _rework = [[runData_ objectForKey:@"Rework"] intValue];
    _reject = [[runData_ objectForKey:@"Reject"] intValue];
    _status = [runData_ objectForKey:@"Status"];
    _shipping = [runData_ objectForKey:@"Shipping"];
    //_sequence = [[runData_ objectForKey:@"Sequence"] intValue];
    [runData setValue:_status forKey:@"Status"];
    //[runData setValue:[runData_ objectForKey:@"Quantity"] forKey:@"Qty"];
    [runData setValue:[runData_ objectForKey:@"Shipped"] forKey:@"Shipped"];
    [runData setValue:[runData_ objectForKey:@"Ready"] forKey:@"Ready"];
    [runData setValue:[runData_ objectForKey:@"Rework"] forKey:@"Rework"];
    [runData setValue:[runData_ objectForKey:@"Reject"] forKey:@"Reject"];
    [runData setValue:[runData_ objectForKey:@"InProcess"] forKey:@"Inprocess"];
    [runData setValue:[runData_ objectForKey:@"Shipping"] forKey:@"Shipping"];
    //[runData setValue:[runData_ objectForKey:@"Sequence"] forKey:@"Sequence"];
    NSLog(@"updated rundata=%@",runData);
}

- (void)updateRunStats:(NSDictionary*)statsData {
    _inProcess = [[statsData objectForKey:@"InProcess"] intValue];
    _rework = [[statsData objectForKey:@"Rework"] intValue];
    _reject = [[statsData objectForKey:@"Reject"] intValue];
    
    [runData setValue:[statsData objectForKey:@"Rework"] forKey:@"Rework"];
    [runData setValue:[statsData objectForKey:@"Reject"] forKey:@"Reject"];
    [runData setValue:[statsData objectForKey:@"InProcess"] forKey:@"Inprocess"];
}

- (NSMutableDictionary*)getRunData {
    return runData;
}

- (int)getRunId {
    return self.runId;
}

- (int)getQuantity {
    return _quantity;
}

- (int)getReject {
    return _reject;
}

- (int)getRework {
    return _rework;
}

- (int)getProductId {
    return _productId;
}

- (NSString*)getRunType {
    return _runType;
}

- (NSString*)getProductNumber {
    return _productNumber;
}

- (NSString*) getRunFlowId {
    return [NSString stringWithFormat:@"%d_%@-%@-%@",[self getRunId],[self getProductNumber], @"PC1",@"1.0"];
}

- (NSString*)getProductName {
    return self.productName;
}

- (NSString*)getVendorName {
    return _vendorName;
}

- (NSString*)getRequestDate {
    return _requestDate;
}

- (NSString*)getRunDate {
    return _runDate;
}

- (NSString*)getStatus {
    return _status;
}

- (NSString*)getDescription {
    return _detail;
}

- (int)getPriority {
    return _priority;
}

- (void)setCategory:(int)category_ {
    _category = category_;
}

- (int)getCategory {
    return _category;
}

- (NSString*) getFullTitle {
    if ([self getCategory] == 0)
        return [NSString stringWithFormat:@"[PCB] %d: %@",[self getRunId], [self getProductName]];
    else
        return [NSString stringWithFormat:@"[ASSM] %d: %@",[self getRunId], [self getProductName]];
}

- (BOOL)isActivated {
    return self.activated;
}

- (void)setRunProcesses:(NSMutableArray*)processesArray {
    runProcesses = processesArray;
    NSLog(@"after setting run processes = %@",runProcesses);
}

- (NSMutableArray*)getRunProcesses {
    return runProcesses;
}

- (NSMutableArray*)getRunFeedbacks {
    return  runFeedbacks;
}

- (void)addRunFeedback:(NSMutableDictionary*)feedbackData {
    [runFeedbacks addObject:feedbackData];
}

- (void)setSequenceNum:(int)sequence_{
    _sequence = sequence_;
    [runData setValue:[NSString stringWithFormat:@"%d",sequence_] forKey:@"Sequence"];
}

- (NSMutableArray*)getRunPartsShort {
    return runPartsShort;
}

- (void)setRunPartsShort:(NSMutableArray*)partsShortArray {
    runPartsShort = partsShortArray;
}

- (void)setRunCompletion:(int)value {
    _completionStatus = value;
}

- (int)getRunCompletion {
    return _completionStatus;
}

- (void)setRunColor:(UIColor*)color {
    runColor = color;
}

- (UIColor*)getRunColor {
    return runColor;
}

- (void)setRunFlowProcesses:(NSMutableArray*)flowProcessesArray {
    runFlowProcesses = flowProcessesArray;
}

- (NSMutableArray*)getRunFlowProcesses {
    return runFlowProcesses;
}

@end
