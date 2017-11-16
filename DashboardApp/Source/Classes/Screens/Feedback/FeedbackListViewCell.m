//
//  FeedbackListViewCell.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 14/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FeedbackListViewCell.h"

@implementation FeedbackListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(NSMutableDictionary*)cellData {
    _productLabel.text = [NSString stringWithFormat:@"%@: %@",cellData[@"Feedback Id"],cellData[@"Product Name"]];
    _receivedLabel.text = cellData[@"Received"];
    _categoryLabel.text = cellData[@"Category"];
    _defectQtyLabel.text = cellData[@"Defect Qty"];
    _statusLabel.text = cellData[@"Status"];
    _notesTextView.text = cellData[@"Subject"];
}

@end
