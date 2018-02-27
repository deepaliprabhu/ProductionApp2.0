//
//  PlanningView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 20/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "PlanningProcessCell.h"

@protocol PlanningViewProtocol;

@interface PlanningView : UIView <UITableViewDelegate, UITableViewDataSource, PlanningProcessCellProtocol, UIAlertViewDelegate>

@property (nonatomic, unsafe_unretained) id <PlanningViewProtocol> delegate;
__CREATEVIEWH(PlanningView)

- (void) reloadData;

@end

@protocol PlanningViewProtocol <NSObject>

- (void) newProcessTimeWasSet;

@end
