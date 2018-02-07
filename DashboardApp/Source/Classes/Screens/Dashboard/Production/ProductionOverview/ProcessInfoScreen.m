//
//  ProcessInfoScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 07/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessInfoScreen.h"
#import "LayoutUtils.h"

@interface ProcessInfoScreen ()

@end

@implementation ProcessInfoScreen {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_idLabel;
    __weak IBOutlet UILabel *_stepLabel;
    
    __weak IBOutlet NSLayoutConstraint *_heightConstraint;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    
    _nameLabel.text = _process.processName;
    _stepLabel.text = _process.stepId;
    _idLabel.text   = _process.processNo;
    
    UIFont *f = [UIFont fontWithName:@"Roboto-Regular" size:16];
    float h = [LayoutUtils heightForText:_process.processName withFont:f andMaxWidth:158 centerAligned:false];
    h = MAX(h, 18);
    _heightConstraint.constant = h;
    [self.view layoutIfNeeded];
    
    self.preferredContentSize = CGSizeMake(280, 85+h);
}

@end
