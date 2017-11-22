//
//  PartModel.h
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartModel : NSObject

@property (nonatomic, strong) NSString *lausanne;
@property (nonatomic, strong) NSString *mason;
@property (nonatomic, strong) NSString *p2;
@property (nonatomic, strong) NSString *pune;
@property (nonatomic, strong) NSString *recoMason;
@property (nonatomic, strong) NSDate *recoMasonDate;
@property (nonatomic, strong) NSString *recoP2;
@property (nonatomic, strong) NSDate *recoP2Date;
@property (nonatomic, strong) NSString *recoPune;
@property (nonatomic, strong) NSDate *recoPuneDate;
@property (nonatomic, strong) NSString *recoS2;
@property (nonatomic, strong) NSDate *recoS2Date;
@property (nonatomic, strong) NSString *s2;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *part;
@property (nonatomic, strong) NSString *po;
@property (nonatomic, strong) NSString *pricePerUnit;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *shortValue;
@property (nonatomic, strong) NSString *transferID;
@property (nonatomic, strong) NSString *transit;
@property (nonatomic, strong) NSDate *transitDate;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) NSArray *alternateParts;
@property (nonatomic, strong) NSArray *priceHistory;
@property (nonatomic, unsafe_unretained) int shortQty;
@property (nonatomic, unsafe_unretained) int poQty;

+ (PartModel*) partFrom:(NSDictionary*)data isShort:(BOOL)s;
- (int) totalStock;
- (int) totalPune;

@end
