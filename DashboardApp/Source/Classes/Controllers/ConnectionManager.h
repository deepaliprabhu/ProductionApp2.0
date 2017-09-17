//
//  ConnectionManager.h
//  SentinelNext
//
//  Created by Aginova on 14/10/14.
//  Copyright (c) 2014 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@protocol ConnectionProtocol;
@interface ConnectionManager : NSObject<NSURLConnectionDelegate> {
    NSMutableData *_responseData;
    int tag;
}
__pd(ConnectionProtocol);
- (void)makeRequest:(NSString*)requestUrl;
- (void)makeRequest:(NSString*)requestUrl withTag:(int)tag;
- (void)makePostRequest:(NSMutableURLRequest*)request;
@end

@protocol ConnectionProtocol <NSObject>
- (void) displayErrorWithMessage:(NSString*)errorMessage;
- (void) parseJsonResponse:(NSData*)jsonData;
- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag;

@end
