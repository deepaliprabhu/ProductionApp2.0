//
//  InProcessViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCircularProgressBarView.h"


@interface InProcessViewCell : UITableViewCell {
    IBOutlet UILabel *_runTitleLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UILabel *_progressLabel;
    IBOutlet UIView *_progressView;
    IBOutlet UIImageView *_imageView;
    
    IBOutlet MBCircularProgressBarView *progressBar;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
