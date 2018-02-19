//
//  DemandListView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "NIDropDown.h"
#import "CKCalendarView.h"

@protocol DemandListViewDelegate;
@interface DemandListView : UIView <UITableViewDelegate, UITableViewDataSource, NIDropDownDelegate , CKCalendarDelegate> {
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_shippingDetailView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_pickShippingButton;
    IBOutlet UIButton *_pickRunButton;
    IBOutlet UIButton *_changeOrderButton;
    IBOutlet UITextField *_qtyTF;
    
    NSMutableArray *demandsArray;
    NSMutableArray *runsArray;
    NSMutableArray *shippingOptionsArray;
    NSMutableDictionary *selectedDemand;
    NIDropDown *dropDown;
    
    NSString *selectedShipping;
    int selectedIndex;
    int selectedRunId;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
__pd(DemandListViewDelegate);
__CREATEVIEWH(DemandListView);
- (void)initView;
- (void)setDemandList:(NSMutableArray*)demandList;
@end

@protocol DemandListViewDelegate <NSObject>
- (void) closeSelected;
- (void) showDetailForDemand:(NSMutableDictionary*)demandData;
- (void) updateDemand:(NSMutableDictionary*)demand;
@end
