//
//  DemandsViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UITextView *_notesTextView;
    IBOutlet UILabel *_daysOpenLabel;
    IBOutlet UILabel *_runsLabel;
    IBOutlet UIView *_rightPaneView;
    IBOutlet UIView *_statsView;
    
    IBOutlet UILabel *_urgentQtyLabel;
    IBOutlet UILabel *_urgentDateLabel;
    IBOutlet UILabel *_longTermQtyLabel;
    IBOutlet UILabel *_longTermDateLabel;
    IBOutlet UILabel *_stockQtyLabel;
    IBOutlet UILabel *_stockDateLabel;
    
    
    
    NSMutableArray *demandsArray;
    
    int selectedIndex;
}

@end
