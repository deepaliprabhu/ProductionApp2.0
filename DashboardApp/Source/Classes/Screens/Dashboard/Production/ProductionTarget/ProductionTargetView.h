//
//  ProductionTargetView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ProductionTargetViewProtocol;

@interface ProductionTargetView : UIView

@property (nonatomic, unsafe_unretained) id <ProductionTargetViewProtocol> delegate;

__CREATEVIEWH(ProductionTargetView)

@end

@protocol ProductionTargetViewProtocol <NSObject>

- (void) goBackFromTargetView;

@end
