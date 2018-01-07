//
//  DayLogScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 05/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "DayLogScreen.h"

@interface DayLogScreen ()

@end

@implementation DayLogScreen {
    
    __weak IBOutlet UITextField *_goodField;
    __weak IBOutlet UITextField *_reworkField;
    __weak IBOutlet UITextField *_dateField;
    __weak IBOutlet UITextField *_rejectField;
    __weak IBOutlet UITextField *_targetField;
    __weak IBOutlet UITextField *_operatorField;
    __weak IBOutlet UITextView *_commentsField;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(295, 328);
    
    _goodField.text = [NSString stringWithFormat:@"%d", _log.good];
    _reworkField.text = [NSString stringWithFormat:@"%d", _log.rework];
    _rejectField.text = [NSString stringWithFormat:@"%d", _log.reject];
    _targetField.text = [NSString stringWithFormat:@"%d", _log.target];
    _commentsField.text = _log.comments;
    _operatorField.text = _log.person;
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd MMM yyyy";
    _dateField.text = [f stringFromDate:_log.date];
}



@end
