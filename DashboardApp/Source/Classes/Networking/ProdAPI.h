//
//  TrashAPI.h
//  TrashUp
//
//  Created by Andrei on 29/12/14.
//  Copyright (c) 2014 Andrei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FTPProtocol;

@interface ProdAPI : NSObject

@property (nonatomic, unsafe_unretained) id <FTPProtocol> delegate;
@property (nonatomic, unsafe_unretained) BOOL isReachable;

+ (ProdAPI*) sharedInstance;
+ (NSString*) jsonString:(id)data;

- (void) loginWithUser:(NSString*)user password:(NSString*)pass withCompletion:(void (^)(BOOL success, id response))block;
- (void) updateProduct:(NSString*)productID status:(NSString*)status withCompletion:(void (^)(BOOL success, id response))block;
- (void) updateProduct:(NSString*)productID image:(NSString*)image withCompletion:(void (^)(BOOL success, id response))block;
- (void) setOrder:(int)o forProduct:(NSString*)productID withCompletion:(void (^)(BOOL success, id response))block;
- (void) setOrder:(int)o forRun:(NSString*)runID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getPartsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getShortsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getPurchasesForPart:(NSString*)partID withCompletion:(void (^)(BOOL, id))block;
- (void) getCommentsForRun:(NSString*)runID withCompletion:(void (^)(BOOL, id))block;
- (void) getCommentsForPart:(NSString*)partID withCompletion:(void (^)(BOOL, id))block;
- (void) addComment:(NSString*)message forRun:(NSString*)runID from:(NSString*)user withCompletion:(void (^)(BOOL, id))block;
- (void) addComment:(NSString*)message forPart:(NSString*)partID from:(NSString*)user withCompletion:(void (^)(BOOL, id))block;
- (void) uploadPhoto:(NSData*)img name:(NSString*)name forProductID:(NSString*)productID delegate:(id <FTPProtocol>)d;
- (void) getRunsFor:(NSString*)partID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getHistoryFor:(NSString*)part withCompletion:(void (^)(BOOL success, id response))block;
- (void) setPurchase:(NSString*)poID date:(NSString*)date completion:(void (^)(BOOL success, id response))block;
- (void) getAuditHistoryFor:(NSString*)part withCompletion:(void (^)(BOOL success, id response))block;
- (void) reconcilePart:(NSString*)part atLocation:(NSString*)l withQty:(NSString*)qty completion:(void (^)(BOOL success, id response))block;
- (void) lockRun:(int)runID withAllocations:(NSString*)json completion:(void (^)(BOOL success, id response))block;
- (void) getSalesPerYearFor:(NSString*)product completion:(void (^)(BOOL success, id response))block;
- (void) getProcessFlowForRun:(int)runId product:(NSString*)product completion:(void (^)(BOOL success, id response))block;
- (void) getProcessFlowForProduct:(NSString*)product completion:(void (^)(BOOL success, id response))block;
- (void) getDailyLogForRun:(int)runId product:(NSString*)product completion:(void (^)(BOOL success, id response))block;
- (void) addDailyLog:(NSString*)log forRunFlow:(NSString*)flow completion:(void (^)(BOOL success, id response))block;
- (void) getBOMForRun:(int)runId completion:(void (^)(BOOL success, id response))block;
- (void) getActiveTestsWithCompletion:(void (^)(BOOL success, id response))block;
- (void) getPassiveTestsWithCompletion:(void (^)(BOOL success, id response))block;
- (void) markHardToGetPart:(NSString*)part completion:(void (^)(BOOL success, id response))block;
- (void) scheduleRun:(int)runId onDate:(NSString*)date forProcess:(NSString*)process completion:(void (^)(BOOL success, id response))block;
- (void) freeSlotForRun:(int)runId onDate:(NSString*)date forProcess:(NSString*)process completion:(void (^)(BOOL success, id response))block;
- (void) getSlotsForRun:(int)runId completion:(void (^)(BOOL success, id response))block;

@end

@protocol FTPProtocol <NSObject>

- (void) imageUploaded;
- (void) failImageUpload;

@end
