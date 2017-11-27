//
//  AlternatePartCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 22/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@interface AlternatePartCell : UITableViewCell

- (void) layoutWithPart:(PartModel*)part isLast:(BOOL)last;
- (void) layoutWithShort:(PartModel*)part isLast:(BOOL)last;

@end
