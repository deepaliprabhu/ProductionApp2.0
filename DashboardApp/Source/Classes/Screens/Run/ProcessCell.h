//
//  ProcessCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessModel.h"

@interface ProcessCell : UITableViewCell

- (void) layoutWith:(ProcessModel*)process;

@end
