//
//  FeedbackDetailView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FeedbackDetailView.h"

@implementation FeedbackDetailView
__CREATEVIEW(FeedbackDetailView, @"FeedbackDetailView", 0);

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initView {
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    self.layer.cornerRadius = 8.0f;
}

- (void)setFeedbackData:(NSMutableDictionary*)feedbackData {
    _productNameLabel.text = [NSString stringWithFormat:@"%@: %@", feedbackData[@"Feedback Id"], feedbackData[@"Product Name"]];
    _categoryLabel.text = feedbackData[@"Category"];
    _statusLabel.text = feedbackData[@"Status"];
    _createdByLabel.text = feedbackData[@"By"];
    _rmaIdLabel.text = feedbackData[@"RMA Id"];
    _transferIdLabel.text = feedbackData[@"Transfer Id"];
    _runIdLabel.text = feedbackData[@"Run Id"];
    _locationLabel.text = feedbackData[@"Location"];
    _ownerLabel.text = feedbackData[@"Owner"];
    _totalQtyLabel.text = feedbackData[@"Total Qty"];
    _defectQtyLabel.text = feedbackData[@"Defect Qty"];
    _recvdLabel.text = feedbackData[@"Received"];
    _subTextView.text = feedbackData[@"Subject"];
    _issuesTextView.text = feedbackData[@"Issues"];
    
    NSString *urlString = feedbackData[@"Image Refer"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.contentInset = UIEdgeInsetsMake(-50, -80, -50, -80);
    [_webView loadRequest:urlRequest];
}

- (IBAction)closePressed:(id)sender {
    [self removeFromSuperview];
    [_delegate closeFeedbackDetail];
}

@end
