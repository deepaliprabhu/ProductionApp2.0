//
//  RunProcessStepsView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 07/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "RunProcessStepsViewCell.h"
#import "CommonProcessesViewCell.h"
#import "Run.h"

@protocol RunProcessStepsViewDelegate;
@interface RunProcessStepsView : UIView {
    IBOutlet UILabel *_runTitleLabel;
    IBOutlet UITableView *_runProcessesTableView;
    IBOutlet UITableView *_commonProcessesTableView;
    IBOutlet UIView *_commonProcessesView;
    IBOutlet UIImageView *_createProcessImageView;
    IBOutlet UIImageView *_submitImageView;
    
    IBOutlet UIButton *_processFlowButton;
    IBOutlet UIButton *_documentationButton;
    IBOutlet UIButton *_historyButton;
    IBOutlet UIButton *_reportsButton;
    IBOutlet UIButton *_ganttButton;
    IBOutlet UIButton *_submitButton;
    
    Run *run;
    
    NSMutableArray *processStepsArray;
    NSMutableArray *commonProcessesArray;
}
__pd(RunProcessStepsViewDelegate);
__CREATEVIEWH(RunProcessStepsView);
- (void)initView;
- (void)setRun:(Run*)run_;

@end

@protocol RunProcessStepsViewDelegate <NSObject>
- (void)closeProcessStepsView;
@end
