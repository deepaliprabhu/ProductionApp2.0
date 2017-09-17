//
//  TasklistView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface TasklistView : UIView<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;

    NSMutableArray *tasksArray;
}
__CREATEVIEWH(TasklistView);
- (void)initView;
@end
