//
//  RunScheduleCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RunScheduleCellProtocol;

@interface RunScheduleCell : UICollectionViewCell

@property (nonatomic, unsafe_unretained) id <RunScheduleCellProtocol> delegate;

- (void) layoutWithWeek:(int)week selectedSlotIndex:(NSIndexPath*)index selectedSlotWeek:(int)selectedWeek slots:(NSArray*)slots;

@end

@protocol RunScheduleCellProtocol <NSObject>

- (void) slotWasSelectedAtIndex:(NSIndexPath *)index forWeek:(int)week;
- (void) fullSlotWasSelected:(NSDictionary*)slot forWeek:(int)week;

@end
