//
//  PackagingCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 11/04/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunDetailsScreen.h"

@protocol PackagingCellProtocol;

@interface PackagingCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <PackagingCellProtocol> delegate;

- (void) layoutWith:(PackagingModel*)model atIndex:(int)index;

@end

@protocol PackagingCellProtocol <NSObject>

- (void) presentShipToOptionsForOrderAtIndex:(int)index;

@end
