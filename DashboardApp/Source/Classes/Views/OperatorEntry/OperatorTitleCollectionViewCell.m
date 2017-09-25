//
//  OperatorTitleCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "OperatorTitleCollectionViewCell.h"

@implementation OperatorTitleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index{
    if (cellData[@"Title"]) {
        _titleLabel.text= cellData[@"Title"];
    }
    
}

@end
