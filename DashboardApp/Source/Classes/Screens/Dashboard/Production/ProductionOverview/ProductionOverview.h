//
//  ProductionOverview.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProductionRunCell.h"

@protocol ProductionOverviewProtocol;

@interface ProductionOverview : UIView <UITableViewDelegate, UITableViewDataSource, ProductionRunCellProtocol>

@property (nonatomic, unsafe_unretained) id <ProductionOverviewProtocol> delegate;

__CREATEVIEWH(ProductionOverview)

@end

@protocol ProductionOverviewProtocol <NSObject>

- (void) goToTargets;
- (void) showDetailsForRun:(Run*)r;

@end
