//
//  CommonProcessesViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol CommonProcessesViewCellDelegate;
@interface CommonProcessesViewCell : UITableViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_addButton;
    IBOutlet UIButton *_editButton;

    int index;
    BOOL added;
}
__pd(CommonProcessesViewCellDelegate);
- (void)setCellData:(NSMutableDictionary *)cellData index:(int)index isAdded:(BOOL)added;
@end

@protocol CommonProcessesViewCellDelegate <NSObject>
- (void)addButtonPressedAtIndex:(int)index withValue:(BOOL)isAdded;
- (void)editProcessAtIndex:(int)index;
@end
