//
//  OperatorEntryCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "OperatorEntryCollectionViewCell.h"

@implementation OperatorEntryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index {
    if (cellData[@"Title"]) {
        _titleTF.text = cellData[@"Title"];
    }
    if (index == 0) {
        _titleTF.userInteractionEnabled = false;
    }
}
@end
