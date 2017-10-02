//
//  RunPartsViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunPartsViewCell.h"

@implementation RunPartsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _partNameLabel.text = cellData[@"part"];
    _shortLabel.text = cellData[@"count"];
    _masonStockLabel.text = cellData[@"Mason"];
    _puneStockLabel.text = cellData[@"Pune"];
    _recoPuneLabel.text = cellData[@"RECO_PUNE"];
    _recoMasonLabel.text = cellData[@"RECO_MASON"];
    if ([cellData[@"color"] isEqualToString:@"red"]) {
        _partNameLabel.textColor = [UIColor redColor];
    }
    if ([cellData[@"color"] isEqualToString:@"yellow"]) {
        _partNameLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:160.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
    }
}

@end
