//
//  WeeklyGraphCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 07/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyGraphCell : UICollectionViewCell

+ (CGFloat) widthForProcessCount:(NSUInteger)c;
- (void) layoutWithDay:(NSDate*)day processes:(NSArray*)prs max:(long)max;

@end
