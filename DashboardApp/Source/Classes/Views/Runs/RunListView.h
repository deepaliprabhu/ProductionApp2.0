//
//  RunListView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 15/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "RunListViewCell.h"
#import "Run.h"

@protocol RunListViewDelegate;
@interface RunListView : UIView<UITableViewDelegate, UITableViewDataSource, RunListViewCellProtocol> {
    
    IBOutlet UIButton *_pcbButton;
    IBOutlet UIButton *_assmButton;
    IBOutlet UIButton *_devButton;
    IBOutlet UIButton *_orderButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UIImageView *_downImageView;
}

__pd(RunListViewDelegate);
__CREATEVIEWH(RunListView);

- (void)setRunList:(NSMutableArray*)runList;
- (Run*)getRunAtLocation:(CGPoint)location;
- (UIView*)getDragView;

@end

@protocol RunListViewDelegate <NSObject>

- (void) showCommentsForRun:(Run*)run;
- (void) runSelectedAtIndex:(int)runId;

@end
