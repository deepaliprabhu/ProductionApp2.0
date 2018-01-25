//
//  RunTargetCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunTargetCell : UICollectionViewCell

- (void) layoutWithRun:(int)run isSelected:(BOOL)selected isFirst:(BOOL)first isLast:(BOOL)last;

@end
