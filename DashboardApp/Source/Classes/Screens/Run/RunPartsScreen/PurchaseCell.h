//
//  PurchaseCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseModel.h"

@interface PurchaseCell : UICollectionViewCell

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index;

@end
