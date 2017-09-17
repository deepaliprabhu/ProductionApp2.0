//
//  TasklistViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol TaskListCellDelegate;
@interface TasklistViewCell : UITableViewCell {
    IBOutlet UILabel *_toLabel;
    IBOutlet UILabel *_fromLabel;
    IBOutlet UILabel *_dueLabel;
    IBOutlet UITextView *_taskTextView;
    IBOutlet UILabel *_taskLabel;
    IBOutlet UIButton *_doneButton;
    IBOutlet UIButton *_trashButton;
    BOOL done;
    int index;
}
__pd(TaskListCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellDat index:(int)index_;

@end

@protocol TaskListCellDelegate <NSObject>
- (void) updateStatus:(BOOL)value forIndex:(int)index;
- (void) deleteTaskAtIndex:(int)index;
@end
