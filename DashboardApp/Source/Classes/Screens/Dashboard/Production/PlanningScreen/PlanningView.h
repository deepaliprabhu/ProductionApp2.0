//
//  PlanningView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 20/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface PlanningView : UIView <UITableViewDelegate, UITableViewDataSource>

__CREATEVIEWH(PlanningView)

- (void) reloadData;

@end
