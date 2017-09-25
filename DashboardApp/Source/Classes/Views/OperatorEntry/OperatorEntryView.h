//
//  OperatorEntryView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface OperatorEntryView : UIView<UICollectionViewDelegate, UICollectionViewDataSource> {
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UICollectionView *_leftCollectionView;
    IBOutlet UIView *_processTitleView;
    IBOutlet UIView *_processNameLineView;
    IBOutlet UIScrollView *_scrollView;
    
    NSMutableArray *titleArray;
    NSMutableArray *processDataArray;
}
__CREATEVIEWH(OperatorEntryView);
- (void)initView;
- (void)setProcessesArray:(NSMutableArray*)processesArray;
@end
