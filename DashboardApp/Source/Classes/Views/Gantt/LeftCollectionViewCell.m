//
//  LeftCollectionViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 30/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LeftCollectionViewCell.h"

@implementation LeftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(NSMutableDictionary*)cellData rowIndex:(int)index{
    _titleLabel.text= cellData[@"Title"];
}
@end
