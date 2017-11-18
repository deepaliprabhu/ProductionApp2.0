//
//  FeedbackListViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackListViewController : UIViewController {
    IBOutlet UITableView *_tableView;
    NSMutableArray *feedbacksArray;
    int selectedIndex;
}
- (void)setFeedbacksList:(NSMutableArray*)feedbacksList;
@end
