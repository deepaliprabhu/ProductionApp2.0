//
//  ConnectionManager.m
//  SentinelNext
//
//  Created by Aginova on 14/10/14.
//  Copyright (c) 2014 Aginova. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

#pragma mark NSURLConnection Delegate Methods

- (void)makeRequest:(NSString*)requestUrl
{
    // Create the request.
    NSLog(@"connecting: %@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"request made %@", conn);
     _responseData = [[NSMutableData alloc] init];
}

- (void)makeRequest:(NSString*)requestUrl withTag:(int)tag_
{
    // Create the request.
    NSLog(@"connecting: %@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"request made %@", conn);
    _responseData = [[NSMutableData alloc] init];
    tag = tag_;
}

- (void)makePostRequest:(NSMutableURLRequest*)request {
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"request made %@", conn);
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    NSLog(@"response received");
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"data received:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    if (!_delegate) {
        return;
    }

    if ( [_delegate respondsToSelector:@selector(parseJsonResponse:)] )
    {
        [_delegate parseJsonResponse:_responseData withTag:tag];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"connection failed: %@",[error description]);
    if ( [_delegate respondsToSelector:@selector(displayErrorWithMessage:)] )
    {
        [_delegate displayErrorWithMessage:[error localizedDescription]];
    }
    //[_delegate parseJsonResponse:_responseData];
}
@end
