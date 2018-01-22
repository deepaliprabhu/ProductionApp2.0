//
//  AlternateShortsCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@interface AlternateShortsCell : UITableViewCell

- (void) layoutWithShort:(PartModel*)part isLast:(BOOL)last;

@end
