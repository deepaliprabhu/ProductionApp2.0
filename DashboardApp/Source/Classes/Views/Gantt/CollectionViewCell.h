//
//  CollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 26/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface CollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_runIdLabel;
    IBOutlet UIView *_rightBorderView;
    UIView *movableView;
    NSMutableArray *runsArray;
    
}
- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index;
- (void)addRun:(Run*)run;
- (UIView*)getMovableView;
- (void)setMovableView:(UIView*)view;
- (void)clearMovableView;
@end
