//
//  OperatorEntryCollectionViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorEntryCollectionViewCell : UICollectionViewCell {
    IBOutlet UITextField *_titleTF;
}
- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index;

@end
