//
//  ProductModel.h
//  DashboardApp
//
//  Created by viggo on 05/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *pcbProductID;
@property (nonatomic, strong) NSString *productNumber;
@property (nonatomic, strong) NSString *productStatus;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *processCntrlId;;
@property (nonatomic, strong) NSMutableArray *processSteps;
@property (nonatomic, unsafe_unretained) int order;

+ (ProductModel*) objectFrom:(NSDictionary*)data;
- (BOOL) isVisible;
- (NSURL*) photoURL;
- (NSMutableArray*)getProcessSteps;
- (void)setProcessSteps:(NSMutableArray *)processSteps;
@end
