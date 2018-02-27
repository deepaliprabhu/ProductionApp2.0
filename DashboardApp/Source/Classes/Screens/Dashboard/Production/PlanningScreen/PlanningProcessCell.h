//
//  PlanningProcessCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessModel.h"

@protocol PlanningProcessCellProtocol;

@interface PlanningProcessCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id <PlanningProcessCellProtocol> delegate;

- (void) layoutWithPlanning:(ProcessModel*)process leftQty:(int)qty target:(int)target atIndex:(int)index;

@end

@protocol PlanningProcessCellProtocol <NSObject>

- (void) changeTimeForProcessAtIndex:(int)index;

@end
