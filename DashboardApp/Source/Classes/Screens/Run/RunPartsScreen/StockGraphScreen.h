//
//  StockGraphScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@interface StockGraphScreen : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, unsafe_unretained) PartModel *part;

@end
