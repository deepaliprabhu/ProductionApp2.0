//
//  TasklistView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "NIDropDown.h"
#import "CKCalendarView.h"

@interface TasklistView : UIView<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NIDropDownDelegate, CKCalendarDelegate> {
    IBOutlet UIButton *_addButton;
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_addTaskView;
    IBOutlet UIButton *_assignedByButton;
    IBOutlet UIButton *_assignedToButton;
    IBOutlet UIButton *_dueDateButton;
    IBOutlet UITextView *_taskTextView;
    
    NIDropDown *dropDown;
    
    NSMutableArray *tasksArray;
    NSMutableArray *namesArray;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
__CREATEVIEWH(TasklistView);
- (void)initView;
@end
