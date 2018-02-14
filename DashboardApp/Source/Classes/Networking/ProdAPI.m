//
//  ProdAPI.m
//  ProdAPI
//
//  Created by Andrei on 29/10/17.
//  Copyright (c) 2017 Andrei. All rights reserved.
//

#import "ProdAPI.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "BRRequest.h"
#import "BRRequestUpload.h"
#import "LoadingView.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserManager.h"

static ProdAPI *_sharedInstance = nil;

@interface ProdAPI() <BRRequestDelegate>

@property (nonatomic, strong) Reachability *internetReachability;

@end

@implementation ProdAPI
{
    AFHTTPSessionManager *_manager;
    BOOL _ftpRequestAlreadyStarted;
    
    BRRequestUpload *uploadFile;
    NSData *uploadData;
}

+ (ProdAPI*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
        [_sharedInstance initData];
        [_sharedInstance checkForReachability];
    });
    
    return _sharedInstance;
}

+ (NSString*) jsonString:(id)data {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    if (!jsonData) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

- (void) initData
{
    _manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    _manager.responseSerializer = serializer;
    
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    _manager.requestSerializer = requestSerializer;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    _manager.securityPolicy = securityPolicy;
}

- (void) loginWithUser:(NSString*)user password:(NSString*)pass withCompletion:(void (^)(BOOL success, id response))block {
    
    NSString *url = @"http://aginova.info/aginova/json/processes.php?call=Login";
    [self callPOST:url parameters:@{@"uid":user, @"pwd":pass} completion:block];
}

- (void) getAuditHistoryFor:(NSString*)part withCompletion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/parts_audit_history?partno=%@", part];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getHistoryFor:(NSString*)part withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/parts_audit_history?PO=true&partno=%@", part];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) updateProduct:(NSString*)productID image:(NSString*)image withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_product_images&productid=%@&images=%@", productID, image];
    [self callGETURL:url completion:block];
}

- (void) updateProduct:(NSString*)productID status:(NSString*)status withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=update_product_status&productid=%@&status=%@", productID, status];
    [self callGETURL:url completion:block];
}

- (void) setOrder:(int)o forProduct:(NSString*)productID withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=update_product_image_order&productid=%@&order=%@", productID, [NSString stringWithFormat:@"%d", o]];
    [self callGETURL:url completion:block];
}

- (void) setOrder:(int)o forRun:(NSString*)runID withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_run_order&runid=%@&order=%d", runID, o];
    [self callGETURL:url completion:block];
}

- (void) getRunsFor:(NSString*)partID withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/parts_for_runs.php?partno=%@", partID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getPartsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_run_parts.php?id=%ld", (long)runID];
    [self callGETURL:url completion:block];
}

- (void) getShortsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_short_parts.php?id=%ld", (long)runID];
    [self callGETURL:url completion:block];
}

- (void) getPurchasesForPart:(NSString*)partID withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=parts_po&partno=%@", partID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getCommentsForRun:(NSString*)runID withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=get_run_comments&runid=%@", runID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getCommentsForPart:(NSString*)partID withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=get_part_comments&partno=%@", partID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) addComment:(NSString*)message forRun:(NSString*)runID from:(NSString*)user withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_run_comments&runid=%@&comments=%@&by=%@", runID, message, user];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) addComment:(NSString*)message forPart:(NSString*)partID from:(NSString*)user withCompletion:(void (^)(BOOL, id))block
{
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=add_part_comments&partno=%@&description=%@&by=%@", partID, message, user];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) setPurchase:(NSString*)poID date:(NSString*)date completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_po_date&poid=%@&expectdate=%@", poID, date];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) reconcilePart:(NSString*)part atLocation:(NSString*)l withQty:(NSString*)qty completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=reconcile_part&partno=%@&location=%@&by=%@&mode=RECONCILE_PARTS&qty=%@", part, l, [[UserManager sharedInstance] loggedUser].username, qty];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) lockRun:(int)runID withAllocations:(NSString*)json completion:(void (^)(BOOL success, id response))block {

    NSString *email = [[[UserManager sharedInstance] loggedUser] username];
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/lock_run.php?runid=%d", runID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callPOST:url parameters:@{@"json":json, @"runid":@(runID), @"user": email} completion:block];
}

- (void) getSalesPerYearFor:(NSString*)product completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/product_sales.php?pid=%@", product];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getProcessFlowForRun:(int)runId product:(NSString*)product completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getRunProcessFlow&run_flow_id=%d_%@-%@-%@",runId,product, @"PC1",@"1.0"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getProcessFlowForProduct:(NSString *)product completion:(void (^)(BOOL, id))block {
    
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@-%@", product, @"PC1",@"1.0"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getDailyLogForRun:(int)runId product:(NSString*)product completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=getRunProcessFlow&run_flow_id=%d_%@-%@-%@",runId,product, @"PC1",@"1.0"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) addDailyLog:(NSString*)log forRunFlow:(NSString*)flow completion:(void (^)(BOOL success, id response))block {
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *time = [f stringFromDate:[NSDate date]];
    NSString *updatedBy = [[[UserManager sharedInstance] loggedUser] name];
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=updateRunProcessFlow&do=update&run_flow_id=%@&updatedTimestamp=%@&updatedBy=%@&count=1&json=%@", flow, time, updatedBy, log];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getBOMForRun:(int)runId completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=get_run_buffer_data&runid=%d",runId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getActiveTestsWithCompletion:(void (^)(BOOL success, id response))block {
    NSString *url = @"http://www.aginova.info/aginova/json/processes.php?call=get_test_data&test=active";
    [self callGETURL:url completion:block];
}

- (void) getPassiveTestsWithCompletion:(void (^)(BOOL success, id response))block {
    NSString *url = @"http://www.aginova.info/aginova/json/processes.php?call=get_test_data&test=passive";
    [self callGETURL:url completion:block];
}

- (void) markHardToGetPart:(NSString*)part completion:(void (^)(BOOL success, id response))block {

    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=flag_part&partno=%@",part];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) scheduleRun:(int)runId onDate:(NSString*)date forProcess:(NSString*)process completion:(void (^)(BOOL success, id response))block {
    
    NSString *by = [[[UserManager sharedInstance] loggedUser] username];
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_run_schedule&runid=%d&scheduledate=%@&process=%@&scheduler=%@&status=running",runId, date, process, by];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) freeSlotForRun:(int)runId onDate:(NSString*)date forProcess:(NSString*)process completion:(void (^)(BOOL success, id response))block {
    
    NSString *by = [[[UserManager sharedInstance] loggedUser] username];
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_run_schedule&runid=%d&scheduledate=%@&process=%@&scheduler=%@&status=complete",runId, date, process, by];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getSlotsForRun:(int)runId completion:(void (^)(BOOL success, id response))block {
    
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=get_run_schedule&runid=%d",runId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) setNewPackageValue:(NSString*)value forPart:(NSString*)part completion:(void (^)(BOOL success, id response))block {
 
    NSString *url = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/processes.php?call=update_package&partno=%@&package=%@", part, value];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getPersonsWithCompletion:(void (^)(BOOL success, id response))block {
    
    NSString *url = @"http://www.aginova.info/aginova/json/processes.php?call=get_user_list";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getPreTestsWithCompletion:(void (^)(BOOL success, id response))block {
    
    NSString *url = @"http://www.aginova.info/aginova/json/processes.php?call=get_pre_sensor_data";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

- (void) getPostTestsWithCompletion:(void (^)(BOOL success, id response))block {
    
    NSString *url = @"http://www.aginova.info/aginova/json/processes.php?call=get_post_sensor_data";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self callGETURL:url completion:block];
}

#pragma mark - Factory

- (void) callPOST:(NSString*)url parameters:(NSDictionary*)params completion:(void (^)(BOOL success, id response))block
{
    [_manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        const void *data = [responseObject bytes];
        if (data != nil)
        {
            NSString* respStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            block(YES, respStr);
        }
        else if (block != nil)
            block(YES, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, nil);
    }];
}

- (void) callGETURL:(NSString*)url completion:(void (^)(BOOL success, id response))block
{
    [_manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        const void *data = [responseObject bytes];
        if (data != nil)
        {
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (obj == nil) {
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                NSArray* words = [str componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                str = [words componentsJoinedByString:@""];
                
                obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            }

            block(YES, obj);
        }
        else
            block(YES, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, nil);
    }];
}

- (void) uploadPhoto:(NSData*)img name:(NSString*)name forProductID:(NSString*)productID delegate:(id <FTPProtocol>)d {
    
    if (_ftpRequestAlreadyStarted == true) {
        [LoadingView showShortMessage:@"Please wait for the previous request!"];
        return;
    }
    
    _ftpRequestAlreadyStarted = true;
    _delegate = d;

    uploadData = img;
    uploadFile = [[BRRequestUpload alloc] initWithDelegate: self];
    uploadFile.path = [NSString stringWithFormat:@"/%@", name];
    uploadFile.hostname = @"ftp.aginova.com";
    uploadFile.username = @"andreiapp";
    uploadFile.password = @"An123@3!9";

    [uploadFile start];
}

#pragma mark -

- (NSData *) requestDataToSend: (BRRequestUpload *) request
{
    NSData *temp = uploadData;
    uploadData = nil;
    return temp;
}

- (void) requestCompleted: (BRRequest *) request
{
    uploadFile = nil;
    _ftpRequestAlreadyStarted = false;
    [_delegate imageUploaded];
}

- (void) requestFailed:(BRRequest *) request
{
    _ftpRequestAlreadyStarted = false;
    [_delegate failImageUpload];
}

- (BOOL)shouldOverwriteFileWithRequest:(BRRequest *)request { 
    return true;
}

#pragma mark - Reachability

- (void) checkForReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    _internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
    
    NetworkStatus status = [_internetReachability currentReachabilityStatus];
    switch (status)
    {
        case NotReachable:
            _isReachable = NO;
            break;
        case ReachableViaWiFi:
            _isReachable = YES;
            break;
        case ReachableViaWWAN:
            _isReachable = YES;
            break;
        default:
            break;
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NetworkStatus status   = [curReach currentReachabilityStatus];
    
    switch (status)
    {
        case NotReachable:
            _isReachable = NO;
            break;
        case ReachableViaWWAN:
            _isReachable = YES;
            break;
        case ReachableViaWiFi:
            _isReachable = YES;
            break;
    }
}

#pragma mark - Utils

- (NSString *)MD5From:(NSString*)str {
    
    const char * pointer = [str UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    
    return string;
}

@end
