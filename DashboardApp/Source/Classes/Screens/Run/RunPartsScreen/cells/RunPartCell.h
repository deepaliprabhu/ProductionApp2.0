//
//  RunPartCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 14/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunModel.h"

@interface RunPartCell : UITableViewCell

+ (CGFloat) height;
- (void) layoutWith:(RunModel*)run at:(int)index;

@end
