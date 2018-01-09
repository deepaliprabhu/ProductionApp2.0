//
//  DemandsViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DemandsViewCell.h"

@implementation DemandsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _productName.text = cellData[@"Product"];
}

@end
