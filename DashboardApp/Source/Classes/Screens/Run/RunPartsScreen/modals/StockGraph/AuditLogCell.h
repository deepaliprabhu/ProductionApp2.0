//
//  AuditLogCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionModel.h"

@interface AuditLogCell : UITableViewCell

- (void) layoutWithModel:(ActionModel*)model atIndex:(int)idx;

@end
