//
//  TrashAPI.h
//  TrashUp
//
//  Created by Andrei on 29/12/14.
//  Copyright (c) 2014 Andrei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdAPI : NSObject

@property (nonatomic, unsafe_unretained) BOOL isReachable;

+ (ProdAPI*) sharedInstance;
- (void) updateProduct:(NSString*)productID status:(NSString*)status withCompletion:(void (^)(BOOL success, id response))block;

@end
