//
//  OperatorTargetEditableCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorTargetEditableCell.h"

@implementation OperatorTargetEditableCell {
    
    __weak IBOutlet UILabel *_operatorLabel;
    __weak IBOutlet UITextField *_targetField;
    
    int _index;
}

- (void) layoutWithOperator:(NSString*)op andTarget:(NSNumber*)target atIndex:(int)index {
    
    _index = index;
    _operatorLabel.text = op;
    if (target != nil)
        _targetField.text = [target stringValue];
    else
        _targetField.text = nil;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    int val = [textField.text intValue];
    [_delegate setTarget:val atIndex:_index];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
