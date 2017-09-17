//
//  RoadBlocksView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol RoadBlocksViewDelegate;
@interface RoadBlocksView : UIView<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *runsArray;
}
__pd(RoadBlocksViewDelegate);
__CREATEVIEWH(RoadBlocksView);
- (void)initView;

@end

@protocol RoadBlocksViewDelegate <NSObject>
- (void)setRoadBlocksLabel:(int)count;
@end
