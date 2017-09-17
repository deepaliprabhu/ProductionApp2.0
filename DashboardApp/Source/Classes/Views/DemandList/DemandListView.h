//
//  DemandListView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol DemandListViewDelegate;
@interface DemandListView : UIView <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *demandsArray;
}
__pd(DemandListViewDelegate);
__CREATEVIEWH(DemandListView);
- (void)initView;
- (void)setDemandList:(NSMutableArray*)demandList;
@end

@protocol DemandListViewDelegate <NSObject>
- (void) closeSelected;
@end
