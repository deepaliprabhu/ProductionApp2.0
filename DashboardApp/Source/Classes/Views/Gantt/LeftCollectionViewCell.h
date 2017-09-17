//
//  LeftCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 30/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_titleLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index;

@end
