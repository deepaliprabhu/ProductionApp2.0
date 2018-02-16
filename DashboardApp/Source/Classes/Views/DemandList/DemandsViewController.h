//
//  DemandsViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemandListView.h"
#import "NIDropDown.h"
#import "CKCalendarView.h"

@interface DemandsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, DemandListViewDelegate, NIDropDownDelegate, CKCalendarDelegate>{
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UITextView *_notesTextView;
    IBOutlet UILabel *_daysOpenLabel;
    IBOutlet UILabel *_runsLabel;
    IBOutlet UIView *_leftPaneView;
    IBOutlet UIView *_rightPaneView;
    IBOutlet UIView *_statsView;
    IBOutlet UIView *_runsView;
    IBOutlet UIButton *_saveButton;
    IBOutlet UIButton *_editButton;
    
    IBOutlet UILabel *_urgentQtyLabel;
    IBOutlet UILabel *_urgentDateLabel;
    IBOutlet UILabel *_longTermQtyLabel;
    IBOutlet UILabel *_longTermDateLabel;
    IBOutlet UILabel *_stockQtyLabel;
    IBOutlet UILabel *_stockDateLabel;
    IBOutlet UIButton *_pickShippingButton;
    IBOutlet UIButton *_pickRunButton;
    IBOutlet UITextField *_qtyTF;
    
    DemandListView *demandListView;
    NIDropDown *dropDown;
    
    NSMutableArray *demandsArray;
    NSMutableArray *runsArray;
    NSMutableArray *shippingOptionsArray;
    NSMutableDictionary *selectedDemand;
    
    NSString *selectedShipping;
    int selectedIndex;
    int selectedRunId;
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

@property (nonatomic, strong) NSString *productNumber;

@end
