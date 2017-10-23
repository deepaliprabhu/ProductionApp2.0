//
//  OperatorEntryView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "DropDownListView.h"
#import "OperatorEntryCollectionViewCell.h"
#import "Run.h"

@protocol OperatorEntryViewDelegate;
@interface OperatorEntryView : UIView<UICollectionViewDelegate, UICollectionViewDataSource> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UICollectionView *_leftCollectionView;
    IBOutlet UIView *_processTitleView;
    IBOutlet UIView *_processNameLineView;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_tintView;
    
    IBOutlet UILabel *_msgLabel;
    IBOutlet UILabel *_processNameLabel;
    IBOutlet UILabel *_noProcessesLabel;
    IBOutlet UIButton *_closeEditButton;
    IBOutlet UIButton *_saveEditButton;
    IBOutlet UITextField *_qtyAllocatedTF;
    IBOutlet UITextField *_qtyCompletedTF;
    IBOutlet UITextField *_qtyReworkTF;
    IBOutlet UITextField *_qtyRejectTF;
    IBOutlet UIView *_entryView;
    
    UIButton *selectedProcessButton;
    
    DropDownListView * dropDownList;
    OperatorEntryCollectionViewCell *selectedCell;
    Run *run;
    
    NSMutableArray *titleArray;
    NSMutableArray *processDataArray;
    NSMutableArray *commonProcessesArray;
    NSMutableArray *statusOptionsArray;
    
    int selectedColIndex;
}
__pd(OperatorEntryViewDelegate);
__CREATEVIEWH(OperatorEntryView);
- (void)initView;
- (void)setProcessesArray:(NSMutableArray*)processesArray;
- (void)setCommonProcessesArray:(NSMutableArray*)commonProcessesArray_;
- (void)setRun:(Run*)run;
@end

@protocol OperatorEntryViewDelegate <NSObject>
- (void)showBackgroundDimmingView;
- (void)hideBackgroundDimmingView;
- (void)updateProcess:(NSMutableDictionary*)processData;
- (void)updateRunStats:(NSDictionary*)statsData;
@end
