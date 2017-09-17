//
//  RunListViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface RunListViewCell : UITableViewCell {
    IBOutlet UILabel *_runNameLabel;
    IBOutlet UILabel *_statusLabel;
    IBOutlet UILabel *_weekLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_progressLabel;
    IBOutlet UIImageView *_imageView;
    Run *run;
}
- (void)setCellData:(Run*)run_;
- (Run*)getRun;
@end
