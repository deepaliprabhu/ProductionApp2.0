//
//  PlanningProcessCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessModel.h"

@interface PlanningProcessCell : UITableViewCell

- (void) layoutWithPlanning:(ProcessModel*)process;

@end
