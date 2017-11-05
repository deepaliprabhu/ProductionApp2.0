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

static ProdAPI *_sharedInstance = nil;

@interface ProdAPI()
@property (nonatomic, strong) Reachability *internetReachability;
@end

@implementation ProdAPI
{
    AFHTTPSessionManager *_manager;
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

- (void) updateProduct:(NSString*)productID status:(NSString*)status withCompletion:(void (^)(BOOL success, id response))block
{
    NSString *url = [NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=update_product_status&productid=%@&status=%@", productID, status];
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
            NSString* respStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];// [NSString stringWithUTF8String:data];
            block(YES, respStr);
        }
        else
            block(YES, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, nil);
    }];
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
