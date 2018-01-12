//
//  DailyLogCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayLogModel.h"

@interface DailyLogCell : UITableViewCell

- (void) layoutWithLog:(DayLogModel*)log;

@end
