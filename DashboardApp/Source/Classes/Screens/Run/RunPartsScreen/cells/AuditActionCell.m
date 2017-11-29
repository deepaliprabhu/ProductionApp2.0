//
//  AuditActionCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "AuditActionCell.h"

@implementation AuditActionCell
{
    __weak IBOutlet UILabel *_actionLabel;
    __weak IBOutlet UILabel *_modeLabel;
    __weak IBOutlet UILabel *_newQTYLabel;
    __weak IBOutlet UILabel *_prevQTYLabel;
}

- (void) layoutWith:(ActionModel*)m {
    
    _actionLabel.text = m.action;
    _modeLabel.text = m.mode;
    _prevQTYLabel.text = m.prevQTY;
    _newQTYLabel.text = m.qty;
}

@end
