//
//  AuditLogCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "AuditLogCell.h"
#import "Defines.h"

@implementation AuditLogCell {
    
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_locationLabel;
    __weak IBOutlet UILabel *_previousLabel;
    __weak IBOutlet UILabel *_newLabel;
    __weak IBOutlet UILabel *_actionLabel;
    __weak IBOutlet UILabel *_modeLabel;
    __weak IBOutlet UILabel *_refLabel;
}

- (void) layoutWithModel:(ActionModel*)model atIndex:(int)idx {

    _bgView.backgroundColor = idx%2 == 0 ? [UIColor whiteColor] : ccolor(240, 244, 247);
    
    _locationLabel.text = model.location;
    _previousLabel.text = model.prevQTY;
    _newLabel.text = model.qty;
    _actionLabel.text = model.action;
    _modeLabel.text = model.mode;
    _refLabel.text = model.process;
}

@end
