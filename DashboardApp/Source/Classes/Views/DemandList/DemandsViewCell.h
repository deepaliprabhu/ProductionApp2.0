//
//  DemandsViewCell.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 08/01/18.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandsViewCell : UITableViewCell {
    IBOutlet UILabel *_productName;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
