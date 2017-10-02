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

@protocol OperatorEntryViewDelegate;
@interface OperatorEntryView : UIView<UICollectionViewDelegate, UICollectionViewDataSource> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UICollectionView *_leftCollectionView;
    IBOutlet UIView *_processTitleView;
    IBOutlet UIView *_processNameLineView;
    IBOutlet UIScrollView *_scrollView;
    
    UIButton *selectedProcessButton;
    
    DropDownListView * dropDownList;
    
    NSMutableArray *titleArray;
    NSMutableArray *processDataArray;
    NSMutableArray *commonProcessesArray;
    NSMutableArray *statusOptionsArray;
}
__pd(OperatorEntryViewDelegate);
__CREATEVIEWH(OperatorEntryView);
- (void)initView;
- (void)setProcessesArray:(NSMutableArray*)processesArray;
- (void)setCommonProcessesArray:(NSMutableArray*)commonProcessesArray_;
@end

@protocol OperatorEntryViewDelegate <NSObject>
- (void)updateProcess:(NSMutableDictionary*)processData;
@end
