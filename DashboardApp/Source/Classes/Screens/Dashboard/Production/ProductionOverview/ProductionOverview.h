//
//  ProductionOverview.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "ProductionProcessCell.h"
#import "Run.h"

@protocol ProductionOverviewProtocol;

@interface ProductionOverview : UIView <UITableViewDelegate, UITableViewDataSource, ProductionProcessCellProtocol>

@property (nonatomic, unsafe_unretained) id <ProductionOverviewProtocol> delegate;

__CREATEVIEWH(ProductionOverview)

- (void) reloadData;

@end

@protocol ProductionOverviewProtocol <NSObject>

- (void) showDetailsForRun:(Run*)r;
- (NSDate*) selectedDate;

@end
