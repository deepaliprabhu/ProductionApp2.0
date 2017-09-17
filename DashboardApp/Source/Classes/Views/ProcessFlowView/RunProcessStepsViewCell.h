//
//  RunProcessStepsViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol RunProcessStepsViewCellDelegate;
@interface RunProcessStepsViewCell : UITableViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_stationLabel;
    IBOutlet UIButton *_crossButton;
    IBOutlet UIButton *_tickButton;
    
    int index;
}
__pd(RunProcessStepsViewCellDelegate);
- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index_;

@end

@protocol RunProcessStepsViewCellDelegate <NSObject>
- (void)crossButtonPressedAtIndex:(int)index;
@end
