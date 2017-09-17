//
//  ToDoViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 28/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoViewCell : UITableViewCell {
    IBOutlet UILabel *_runTitleLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UIImageView *_imageView;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
