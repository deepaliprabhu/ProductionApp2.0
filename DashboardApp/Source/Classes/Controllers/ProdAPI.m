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
#import "GRRequestsManager.h"
#import "LoadingView.h"

static ProdAPI *_sharedInstance = nil;

@interface ProdAPI() <GRRequestsManagerDelegate>

@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) GRRequestsManager *requestsManager;

@end

@implementation ProdAPI
{
    AFHTTPSessionManager *_manager;
    BOOL _ftpRequestAlreadyStarted;
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

- (void) initData
{
    _manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    _manager.responseSerializer = serializer;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    _manager.requestSerializer = requestSerializer;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    _manager.securityPolicy = securityPolicy;
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
//            NSString* respStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];// [NSString stringWithUTF8String:data];
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:name];
    [img writeToFile:imagePath atomically:YES];
    
    if (self.requestsManager == nil) {
        self.requestsManager = [[GRRequestsManager alloc] initWithHostname:@"ftp://ftp.aginova.com" user:@"andreiapp" password:@"An123@3!9"];
        self.requestsManager.delegate = self;
    }
    
    [self.requestsManager addRequestForUploadFileAtLocalPath:imagePath toRemotePath:[NSString stringWithFormat:@"/%@", name]];
    [self.requestsManager startProcessingRequests];
}

#pragma mark -

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didFailRequest:(id<GRRequestProtocol>)request withError:(NSError *)error {
    _ftpRequestAlreadyStarted = false;
    [_delegate failImageUpload];
}

- (void)requestsManager:(id<GRRequestsManagerProtocol>)requestsManager didCompleteUploadRequest:(id<GRDataExchangeRequestProtocol>)request {
    _ftpRequestAlreadyStarted = false;
    [_delegate imageUploaded];
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

@end
