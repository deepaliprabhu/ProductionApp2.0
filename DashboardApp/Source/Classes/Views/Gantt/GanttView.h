//
//  GanttView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 24/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "Run.h"

@interface GanttView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>{
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UICollectionView *_leftCollectionView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_dragView;
    
    NSMutableArray *stationsArray;
    NSMutableArray *datesArray;
}
__CREATEVIEWH(GanttView);
- (void)initView;
- (void)setCellWithRun:(Run*)run andLocation:(CGPoint)location;
- (UIView*)getViewAtLocation:(CGPoint)location;
- (UIView*)getDragView;
- (void)setCellWithView:(UIView*)view atLocation:(CGPoint)location;
- (void)clearViewAtLocation:(CGPoint)location;
- (void)setStationsArrayForRunType:(int)type;
@end
