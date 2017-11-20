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
    _idLabel.text = cellData[@"Feedback Id"];
    _productLabel.text = cellData[@"Product Name"];
    _receivedLabel.text = cellData[@"Received"];
    _categoryLabel.text = cellData[@"Category"];
    if ([cellData[@"Defect Qty"] isEqualToString:@""]) {
    }
    else if ([cellData[@"Total Qty"] isEqualToString:@""]) {
        _defectQtyLabel.text = [NSString stringWithFormat:@"%@",cellData[@"Defect Qty"]];
    }
    else {
    _defectQtyLabel.text = [NSString stringWithFormat:@"%@/%@",cellData[@"Defect Qty"],cellData[@"Total Qty"]];
    }
    _statusLabel.text = cellData[@"Status"];
    _notesTextView.text = cellData[@"Subject"];
    
    NSString *urlString = cellData[@"Image Refer"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(-50, -80, -50, -80);
    [_webView loadRequest:urlRequest];
}

@end
