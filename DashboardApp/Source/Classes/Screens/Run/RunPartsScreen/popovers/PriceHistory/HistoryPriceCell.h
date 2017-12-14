//
//  HistoryPriceCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryPriceCell : UITableViewCell

- (void) layoutWith:(NSDictionary*)data currentPrice:(float)currentPrice atIndex:(int)index;

@end
