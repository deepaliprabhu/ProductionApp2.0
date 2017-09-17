//
//  RunPartsViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunPartsViewCell : UITableViewCell {
    IBOutlet UILabel *_partNameLabel;
    IBOutlet UILabel *_shortLabel;
    IBOutlet UILabel *_needLabel;
    IBOutlet UILabel *_puneStockLabel;
    IBOutlet UILabel *_masonStockLabel;
    IBOutlet UILabel *_recoMasonLabel;
    IBOutlet UILabel *_recoPuneLabel;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
