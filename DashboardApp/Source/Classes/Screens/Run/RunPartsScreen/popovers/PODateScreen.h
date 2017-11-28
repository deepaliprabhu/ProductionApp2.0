//
//  PODateScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseModel.h"

@protocol PODateScreenDelegate;

@interface PODateScreen : UIViewController

@property (nonatomic, unsafe_unretained) id <PODateScreenDelegate> delegate;
@property (nonatomic, unsafe_unretained) PurchaseModel *purchase;

@end

@protocol PODateScreenDelegate <NSObject>

- (void) expectedDateChanged;

@end
