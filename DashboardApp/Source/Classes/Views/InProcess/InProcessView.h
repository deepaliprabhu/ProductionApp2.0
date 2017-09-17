//
//  InProcessView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol InProcessViewDelegate;
@interface InProcessView : UIView<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *runsArray;
}
__pd(InProcessViewDelegate);
__CREATEVIEWH(InProcessView);
- (void)initView;

@end

@protocol InProcessViewDelegate <NSObject>
- (void)setInProcessLabel:(int)count;
@end
