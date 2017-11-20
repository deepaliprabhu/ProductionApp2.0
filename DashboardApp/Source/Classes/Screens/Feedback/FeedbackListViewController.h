//
//  FeedbackListViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackDetailView.h"
#import "NIDropDown.h"


@interface FeedbackListViewController : UIViewController<FeedbackDetailViewDelegate, NIDropDownDelegate> {
    IBOutlet UITableView *_tableView;
    
    UIView *backgroundDimmingView;
    
    NIDropDown *dropDown;

    NSMutableArray *feedbacksArray;
    NSMutableArray *statusArray;
    NSMutableArray *ownerArray;
    NSMutableArray *productArray;
    NSMutableArray *categoryArray;
    NSMutableArray *filteredArray;
    int selectedIndex;
    NSString *selectedStatus;
    NSString *selectedCategory;
    NSString *selectedOwner;
    NSString *selectedProduct;
}
- (void)setFeedbacksList:(NSMutableArray*)feedbacksList;
@end
