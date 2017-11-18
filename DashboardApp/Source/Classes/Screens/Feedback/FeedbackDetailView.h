//
//  FeedbackDetailView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface FeedbackDetailView : UIView {
    IBOutlet UILabel *_productNameLabel;
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_createdByLabel;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_ownerLabel;
    IBOutlet UILabel *_rmaIdLabel;
    IBOutlet UILabel *_transferIdLabel;
    IBOutlet UILabel *_runIdLabel;
    IBOutlet UILabel *_recvdLabel;
    IBOutlet UILabel *_totalQtyLabel;
    IBOutlet UILabel *_defectQtyLabel;
    IBOutlet UITextView *_subTextView;
    IBOutlet UITextView *_issuesTextView;
    IBOutlet UIWebView *_webView;
}
__CREATEVIEWH(FeedbackDetailView);
- (void)initView;
- (void)setFeedbackData:(NSMutableDictionary*)feedbackData;
@end
