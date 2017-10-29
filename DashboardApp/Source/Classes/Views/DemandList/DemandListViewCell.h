//
//  DemandListViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 17/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol DemandListViewCellDelegate;
@interface DemandListViewCell : UITableViewCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_daysOpenLabel;
    IBOutlet UILabel *_immediateLabel;
    IBOutlet UILabel *_immediateDateLabel;
    IBOutlet UILabel *_longTermlabel;
    IBOutlet UILabel *_longTermDateLabel;
    IBOutlet UILabel *_stockLabel;
    IBOutlet UILabel *_stockDateLabel;
    IBOutlet UILabel *_shippingLabel;
    IBOutlet UILabel *_runsLabel;
    IBOutlet UIButton *_photoButton;
    IBOutlet UIButton *_shippingButton;
    IBOutlet UITextView *_notesTextView;
}
__pd(DemandListViewCellDelegate);
- (void)setCellData:(NSMutableDictionary*)cellData;
- (void)setExpectedDate:(NSString*)dateString;
@end

@protocol DemandListViewCellDelegate <NSObject>
- (void) closeSelected;
@end
