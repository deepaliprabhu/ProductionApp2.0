//
//  PurchaseModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseModel : NSObject

@property (nonatomic, strong) NSString *poID;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSDate *expectedDate;

+ (PurchaseModel*) objFrom:(NSDictionary*)data;

@end
