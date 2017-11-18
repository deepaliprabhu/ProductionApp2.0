//
//  PriorityRunCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 16/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface PriorityRunCell : UITableViewCell

- (void) layoutWith:(Run*)run at:(int)index containsPart:(BOOL)c;

@end
