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
- (void) updateProduct:(NSString*)productID status:(NSString*)status withCompletion:(void (^)(BOOL success, id response))block;
- (void) updateProduct:(NSString*)productID image:(NSString*)image withCompletion:(void (^)(BOOL success, id response))block;
- (void) setOrder:(int)o forProduct:(NSString*)productID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getPartsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getShortsForRun:(NSInteger)runID withCompletion:(void (^)(BOOL success, id response))block;
- (void) getPurchasesForPart:(NSString*)partID withCompletion:(void (^)(BOOL, id))block;
- (void) uploadPhoto:(NSData*)img name:(NSString*)name forProductID:(NSString*)productID delegate:(id <FTPProtocol>)d;

@end

@protocol FTPProtocol <NSObject>

- (void) imageUploaded;
- (void) failImageUpload;

@end
