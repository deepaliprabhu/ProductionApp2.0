//
//  DailyLogCollectionCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayLogModel.h"

@interface DailyLogCollectionCell : UICollectionViewCell

- (void) layoutWithDayLog:(NSArray*)logs maxVal:(int)max;

@end
