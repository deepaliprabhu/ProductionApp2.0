//
//  FeedbackListView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 14/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol FeedbackListViewDelegate;
@interface FeedbackListView : UIView {
    IBOutlet UITableView *_tableView;
    NSMutableArray *feedbacksArray;
    
    int selectedIndex;
}
__CREATEVIEWH(FeedbackListView);
- (void)initView;
- (void)setFeedbacksList:(NSMutableArray*)feedbacksList;
__pd(FeedbackListViewDelegate);

@end

@protocol FeedbackListViewDelegate <NSObject>
- (void) closeSelected;
@end
