//
//  PurchasePartCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseModel.h"

@protocol PurchaseCellProtocol;

@interface PurchasePartCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <PurchaseCellProtocol> delegate;

- (void) layoutWith:(PurchaseModel*)m atIndex:(int)index;

@end

@protocol PurchaseCellProtocol <NSObject>

- (void) expectedDateButtonTappedAtIndex:(int)index position:(CGRect)rect;

@end
