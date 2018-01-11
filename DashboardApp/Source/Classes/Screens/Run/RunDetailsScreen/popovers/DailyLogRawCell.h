//
//  DailyLogRawCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 11/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayLogModel.h"

@interface DailyLogRawCell : UITableViewCell

- (void) layoutWithLog:(DayLogModel*)model atIndex:(int)idx;

@end
