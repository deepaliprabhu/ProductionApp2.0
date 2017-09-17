//
//  ToDoView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol ToDoViewDelegate;
@interface ToDoView : UIView<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *runsArray;
}
__pd(ToDoViewDelegate);
__CREATEVIEWH(ToDoView);
- (void)initView;

@end

@protocol ToDoViewDelegate <NSObject>
- (void)setToDoLabel:(int)count;
@end
