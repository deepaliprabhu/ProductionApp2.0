//
//  RunListView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 15/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "RunListTableView.h"
#import "Run.h"

@protocol RunListViewDelegate;
@interface RunListView : UIView<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIButton *_pcbButton;
    IBOutlet UIButton *_assmButton;
    IBOutlet UIButton *_devButton;
    IBOutlet UIButton *_addButton;
    IBOutlet RunListTableView *_tableView;
    IBOutlet UIImageView *_downImageView;
    IBOutlet UIView *_dragView;
    
    NSMutableArray *runsArray;
    NSMutableArray *filteredRunsArray;
    NSMutableArray *colorsArray;
}
__pd(RunListViewDelegate);
__CREATEVIEWH(RunListView);
- (void)initView;
- (void)setRunList:(NSMutableArray*)runList;
- (Run*)getRunAtLocation:(CGPoint)location;
- (UITableView*)getTableView;
- (UIView*)getDragView;
@end

@protocol RunListViewDelegate <NSObject>
- (void) runSelectedAtIndex:(int)runId;
- (void) selectedRunType:(int)runType;
- (void) closeSelected;
@end
