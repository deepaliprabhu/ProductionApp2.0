//
//  RunDetailsScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 18/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface TransferModel: NSObject

@property (nonatomic, copy) NSString *transferID;
@property (nonatomic, copy) NSString *product;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *trackingID;
@property (nonatomic, copy) NSString *quantity;

@end

@interface PackagingModel: NSObject

@property (nonatomic, copy) NSString *customer;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *qtShip;
@property (nonatomic, copy) NSString *shipTo;
@property (nonatomic, copy) NSString *status;

@end

@interface RunDetailsScreen : UIViewController

@property (nonatomic, strong) Run *run;

@end
