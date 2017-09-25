//
//  RunViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"
#import "RunProcessStepsView.h"
#import "OperatorEntryView.h"

@interface RunViewController : UIViewController {
    IBOutlet UILabel *_runTitleLabel;
    IBOutlet UILabel *_productIdLabel;
    IBOutlet UILabel *_priorityLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_reqDateLabel;
    IBOutlet UILabel *_updatedDateLabel;
    IBOutlet UILabel *_shippingDateLabel;
    IBOutlet UILabel *_versionLabel;
    IBOutlet UILabel *_inProcessLabel;
    IBOutlet UILabel *_readyLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_shippedLabel;
    
    IBOutlet UIButton *_processFlowButton;
    IBOutlet UIButton *_documentationButton;
    IBOutlet UIButton *_historyButton;
    IBOutlet UIButton *_reportsButton;
    IBOutlet UIButton *_ganttButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_photoButton;
    IBOutlet UIView *_tintView;
    IBOutlet UIView *_inProcessView;
    IBOutlet UIView *_readyView;
    IBOutlet UIView *_reworkView;
    IBOutlet UIView *_rejectView;
    IBOutlet UIView *_shippedView;
    IBOutlet UIView *_bottomPaneView;
    
    IBOutlet UILabel *_thisYearCountLabel;
    IBOutlet UILabel *_lastYearCountLabel;
    IBOutlet UILabel *_prevLastYearCountLabel;
    IBOutlet UIView *_thisYearView;
    IBOutlet UIView *_lastYearView;
    IBOutlet UIView *_prevLastYearView;
    
    Run *run;
    RunProcessStepsView *runProcessStepsView;
    OperatorEntryView *operatorEntryView;
    
    NSMutableArray *partsArray;
    NSMutableArray *processesArray;
    NSMutableArray *commonProcessesArray;
    
}
- (void)setRun:(Run*)run_;

@end
