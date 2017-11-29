//
//  AuditActionCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionModel.h"

@interface AuditActionCell : UITableViewCell

- (void) layoutWith:(ActionModel*)m;

@end
