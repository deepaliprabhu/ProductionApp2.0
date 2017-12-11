//
//  PartModel.h
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartAuditModel.h"

@interface PartModel : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *recoMason;
@property (nonatomic, strong) NSDate *recoMasonDate;
@property (nonatomic, strong) NSString *recoP2;
@property (nonatomic, strong) NSDate *recoP2Date;
@property (nonatomic, strong) NSString *recoPune;
@property (nonatomic, strong) NSDate *recoPuneDate;
@property (nonatomic, strong) NSString *recoS2;
@property (nonatomic, strong) NSDate *recoS2Date;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *part;
@property (nonatomic, strong) NSString *po;
@property (nonatomic, strong) NSString *pricePerUnit;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *shortValue;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) NSArray *alternateParts;
@property (nonatomic, strong) NSArray *priceHistory;
@property (nonatomic, strong) NSArray *purchases;
@property (nonatomic, strong) NSArray *runs;
@property (nonatomic, strong) NSString *partDescription;
@property (nonatomic, unsafe_unretained) int shortQty;
@property (nonatomic, strong) PartAuditModel *audit;
@property (nonatomic, unsafe_unretained) BOOL isAlternate;

+ (PartModel*) partFrom:(NSDictionary*)data;
- (int) totalStock;
- (int) openPOQty;
- (ActionModel*) transitAction;

- (void) getHistory;
- (void) getPurchases;

@end
