//
//  PartsCell.h
//  DashboardApp
//
//  Created by Viggo IT on 08/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@interface PartsCell : UITableViewCell

- (void) layoutWithPart:(PartModel*)m;
- (void) layoutWithShort:(PartModel*)m;

@end
