//
//  ProductProcessStepsView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 29/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "RunProcessStepsViewCell.h"
#import "CommonProcessesViewCell.h"
#import "Run.h"
#import "DropDownListView.h"
#import "ProductModel.h"

@protocol ProductProcessStepsViewDelegate;
@interface ProductProcessStepsView : UIView<kDropDownListViewDelegate> {
    IBOutlet UILabel *_runTitleLabel;
    IBOutlet UILabel *_versionLabel;
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
    IBOutlet UIButton *_statusButton;
    
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_pointsLabel;
    IBOutlet UILabel *_operator1Label;
    IBOutlet UILabel *_operator2Label;
    IBOutlet UILabel *_operator3Label;
    IBOutlet UITableView *_wiTableView;
    IBOutlet UIView *_processInfoView;
    
    DropDownListView * dropDownList;
    
    NSMutableArray *processStepsArray;
    NSMutableArray *commonProcessesArray;
    NSMutableArray *selectedProcessesArray;
    NSMutableArray *workInstructionsArray;
    NSMutableArray *statusOptionsArray;
    
    ProductModel *_product;
    
    NSString *processCntrlId;
}
__pd(ProductProcessStepsViewDelegate);
__CREATEVIEWH(ProductProcessStepsView);
- (void)initView;
- (void)setProductData:(ProductModel*)p;

@end

@protocol ProductProcessStepsViewDelegate <NSObject>
- (void)closeProcessStepsView;
@end
