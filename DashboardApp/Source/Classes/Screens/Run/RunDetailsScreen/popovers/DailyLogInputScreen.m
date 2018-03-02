//
//  DailyLogInputScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DailyLogInputScreen.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "UserManager.h"
#import "Defines.h"

#define kTextViewPlaceholder @"enter comments"

@interface DailyLogInputScreen () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation DailyLogInputScreen {
    
    __weak IBOutlet UIImageView *_backgroundImageView;
    
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UITextField *_targetTextField;
    __weak IBOutlet UITextField *_goodTextField;
    __weak IBOutlet UITextField *_rejectTextField;
    __weak IBOutlet UITextField *_reworkTextField;
    __weak IBOutlet UITextField *_timeTextField;
    __weak IBOutlet UITextView *_commentsTextView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) saveButtonTapped {
 
    if (_operatorName == nil) {
        [LoadingView showShortMessage:@"No operator is selected!"];
        return;
    }
     
    [self.view endEditing:true];
    
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:[self params]];
    NSString *json = [NSString stringWithFormat:@"[%@]" ,[ProdAPI jsonString:log]];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] addDailyLog:json forRunFlow:[_run getRunFlowId] completion:^(BOOL success, id response) {
       
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                if ([response count] > 0) {
                    int dayId = [response[0][@"id"] intValue];
                    log[@"id"] = [NSString stringWithFormat:@"%d", dayId];
                }
            }
            
            [LoadingView removeLoading];
            if (_dayLog == nil)
                [_delegate newLogAdded:log];
            else
                [_delegate updateLog:log];
            [self cancelButtonTapped];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    
    int processed = [_targetTextField.text intValue];
    if (processed == 0 && textField != _targetTextField && textField != _timeTextField) {
        [LoadingView showShortMessage:@"Insert processed first"];
        return false;
    }
    else
        return true;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@"0"])
        textField.text = @"";
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _timeTextField)
        return;
    
    if (textField.text.length == 0) {
        textField.text = @"0";
    }
    
    int processed = [_targetTextField.text intValue];
    int good = [_goodTextField.text intValue];
    int reworked = [_reworkTextField.text intValue];
    
    if (good + reworked <= processed) {
        _rejectTextField.text = [NSString stringWithFormat:@"%d", processed-good-reworked];
    } else {
     
        [LoadingView showShortMessage:@"Invalid input"];
        if (textField == _targetTextField) {
            [self fillDayLog];
        } else {
            textField.text = @"0";
            
            int processed = [_targetTextField.text intValue];
            int good = [_goodTextField.text intValue];
            int reworked = [_reworkTextField.text intValue];
            _rejectTextField.text = [NSString stringWithFormat:@"%d", processed-good-reworked];
        }
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:kTextViewPlaceholder]) {
        textView.text = @"";
        textView.textColor = ccolor(86, 86, 86);
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        textView.text = kTextViewPlaceholder;
        textView.textColor = ccolor(206, 206, 210);
    }
}

#pragma mark - Layout

- (void) initLayout {
    
    _backgroundImageView.image = _image;
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd/MM/yyyy";
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ - %@", _process.processName, [f stringFromDate:[NSDate date]]];
    _commentsTextView.text = kTextViewPlaceholder;
    [self fillDayLog];
}

- (void) fillDayLog {
    
    if (_dayLog != nil) {
        
        _targetTextField.text = [NSString stringWithFormat:@"%d", _dayLog.target];
        _rejectTextField.text = [NSString stringWithFormat:@"%d", _dayLog.reject];
        _reworkTextField.text = [NSString stringWithFormat:@"%d", _dayLog.rework];
        _goodTextField.text = [NSString stringWithFormat:@"%d", _dayLog.good];
        
        if (_dayLog.time.length == 0 || [_dayLog.time isEqualToString:@"0"])
            _timeTextField.text = nil;
        
        if (_dayLog.comments.length > 0)
            _commentsTextView.text = _dayLog.comments;
        
    } else {
    
        _targetTextField.text = @"0";
        _rejectTextField.text = @"0";
        _reworkTextField.text = @"0";
        _goodTextField.text = @"0";
    }
}

#pragma mark - Utils

- (NSDictionary*) params {
    
    int good = [_goodTextField.text intValue];
//    int reject = [_rejectTextField.text intValue];
    int rework = [_reworkTextField.text intValue];
    int target = [_targetTextField.text intValue];
    
    NSMutableDictionary *log = [NSMutableDictionary dictionary];
    //    log[@"stepid"] = _process.stepId;
    log[@"processno"] = _process.processNo;
    log[@"operator"] = _operatorName;
    log[@"comments"] = [_commentsTextView.text isEqualToString:kTextViewPlaceholder] ? @"" : _commentsTextView.text;
    //    log[@"status"] = @"tmp";
    log[@"qtyTarget"] = [NSString stringWithFormat:@"%d", target];
    log[@"qtyGood"] = [NSString stringWithFormat:@"%d", good];
    log[@"qtyRework"] = [NSString stringWithFormat:@"%d", rework];
//    log[@"qtyReject"] = [NSString stringWithFormat:@"%d", reject];
    log[@"qtyGoal"] = [NSString stringWithFormat:@"%d", _dayLog.goal];
    log[@"id"] = @(_dayLog.dayLogID);
    
    if (_timeTextField.text == nil)
        log[@"actualtime"] = @"";
    else
        log[@"actualtime"] = _timeTextField.text;
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    log[@"datetime"] = [f stringFromDate:[NSDate date]];
    
    return log;
}

@end
