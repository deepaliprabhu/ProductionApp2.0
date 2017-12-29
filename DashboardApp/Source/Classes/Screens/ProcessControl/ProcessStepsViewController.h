//
//  ProcessStepsViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 19/12/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import "ProductModel.h"
#import "CommonProcessesViewCell.h"
#import "ProductAdminPopover.h"
#import "NIDropDown.h"

@interface ProcessStepsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ProductAdminPopoverDelegate, NIDropDownDelegate, UITextFieldDelegate> {
    IBOutlet UITableView *_productListTableView;
    IBOutlet UITableView *_processListTableView;
    IBOutlet UIView *_leftPaneView;
    IBOutlet UIView *_rightPaneView;
    IBOutlet UIImageView *_addStepImageView;
    IBOutlet UIImageView *_submitImageView;
    IBOutlet UIButton *_submitButton;
    IBOutlet UIButton *_addStepButton;
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UILabel *_productIdLabel;
    IBOutlet UILabel *_processNoLabel;
    IBOutlet UIImageView *_productImageView;
    
    IBOutlet UIView *_editProcessFlowView;
    IBOutlet UITableView *_commonProcessListTableView;
    IBOutlet UIButton *_saveButton;
    IBOutlet UIButton *_closeButton;
    IBOutlet UIButton *_createStepButton;
    
    IBOutlet UIView *_processInfoView;
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_pointsLabel;
    IBOutlet UILabel *_operator1Label;
    IBOutlet UILabel *_operator2Label;
    IBOutlet UILabel *_operator3Label;
    IBOutlet UITableView *_wiTableView;
    
    IBOutlet UIView *_addProcessView;
    IBOutlet UIButton *_stationIdButton;
    IBOutlet UIButton *_operator1Button;
    IBOutlet UIButton *_operator2Button;
    IBOutlet UIButton *_operator3Button;
    IBOutlet UITextField *_processNameTF;
    IBOutlet UITextField *_timeTF;
    
    UIView *backgroundDimmingView;
    
    DZNSegmentedControl *control;
    NIDropDown *dropDown;
    
    NSMutableArray *productGroupsArray;
    NSMutableArray *productsArray;;
    NSMutableArray *filteredProductsArray;
    NSMutableArray *processStepsArray;
    NSMutableArray *deletedProcessArray;
    NSMutableArray *commonProcessStepsArray;
    NSMutableArray *indexArray;
    NSMutableArray *alteredIndexArray;
    NSMutableArray *alteredProcessesArray;
    NSMutableArray *workInstructionsArray;
    NSMutableDictionary *selectedProcessData;
    NSMutableArray *stationsArray;
    NSMutableArray *operatorArray;
    
    BOOL screenIsForAdmin;
    
    ProductModel *selectedProduct;
    
    NSString *processCntrlId;
    UIPopoverController *_adminPopover;
    
    int selectedStation;
    int selectedIndex;
    int selectedOperatorIndex;
}

@end
