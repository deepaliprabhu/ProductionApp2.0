//
//  FeedbackListViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 14/11/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackListViewCell : UITableViewCell {
    IBOutlet UILabel *_productLabel;
    IBOutlet UILabel *_receivedLabel;
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_defectQtyLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_subjectLabel;
    IBOutlet UITextView *_notesTextView;
}
- (void)setCellData:(NSMutableDictionary*)cellData;

@end
