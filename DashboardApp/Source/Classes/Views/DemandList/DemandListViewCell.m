//
//  DemandListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DemandListViewCell.h"

@implementation DemandListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _nameLabel.text = cellData[@"Product"];
    _daysOpenLabel.text = cellData[@"Days Open"];
    _immediateLabel.text = cellData[@"urgent_qty"];
    _longTermlabel.text = cellData[@"long_term_qty"];
    _stockLabel.text = cellData[@"Mason_Stock"];
    _runsLabel.text = cellData[@"Runs"];
    _shippingLabel.text = cellData[@"Shipping"];
    _immediateDateLabel.text = cellData[@"urgent_when"];
    _longTermDateLabel.text = cellData[@"long_when"];
    _stockDateLabel.text = cellData[@"stock_when"];
    _notesTextView.text = cellData[@"Notes"];
}
@end
