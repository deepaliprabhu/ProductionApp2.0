//
//  OperatorTitleCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorTitleCollectionViewCell : UICollectionViewCell {
    IBOutlet UILabel *_titleLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index;
@end
