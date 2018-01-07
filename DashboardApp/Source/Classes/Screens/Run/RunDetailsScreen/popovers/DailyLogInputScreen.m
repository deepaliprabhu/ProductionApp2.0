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
    
    __weak IBOutlet UITextField *_targetTextField;
    __weak IBOutlet UITextField *_goodTextField;
    __weak IBOutlet UITextField *_rejectTextField;
    __weak IBOutlet UITextField *_reworkTextField;
    __weak IBOutlet UITextField *_dateTextField;
    __weak IBOutlet UITextView *_commentsTextView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (void) cancelButtonTapped {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) saveButtonTapped {
 
    int good = [_goodTextField.text intValue];
    int reject = [_rejectTextField.text intValue];
    int rework = [_reworkTextField.text intValue];
    int target = [_targetTextField.text intValue];
    
    NSMutableDictionary *log = [NSMutableDictionary dictionary];
    log[@"stepid"] = _process.stepId;
    log[@"processno"] = _process.processNo;
    log[@"operator"] = [[[UserManager sharedInstance] loggedUser] name];
    log[@"comments"] = [_commentsTextView.text isEqualToString:kTextViewPlaceholder] ? @"" : _commentsTextView.text;
    log[@"status"] = @"tmp";
    log[@"qtyTarget"] = [NSString stringWithFormat:@"%d", target];
    log[@"qtyGood"] = [NSString stringWithFormat:@"%d", good];
    log[@"qtyRework"] = [NSString stringWithFormat:@"%d", rework];
    log[@"qtyReject"] = [NSString stringWithFormat:@"%d", reject];
    
    NSString *json = [NSString stringWithFormat:@"[%@]" ,[ProdAPI jsonString:log]];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] addDailyLog:json forRunFlow:[_run getRunFlowId] completion:^(BOOL success, id response) {
       
        if (success) {
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
    
    self.title = _process.processName;
    
//    NSDateFormatter *f = [NSDateFormatter new];
//    f.dateFormat = @"dd MMM yyyy";
//    _dateTextField.text = [f stringFromDate:[NSDate date]];
    _dateTextField.text = @"today";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
    
    _commentsTextView.text = kTextViewPlaceholder;
    if (_dayLog != nil) {
        
        _targetTextField.text = [NSString stringWithFormat:@"%d", _dayLog.target];
        _rejectTextField.text = [NSString stringWithFormat:@"%d", _dayLog.reject];
        _reworkTextField.text = [NSString stringWithFormat:@"%d", _dayLog.rework];
        _goodTextField.text = [NSString stringWithFormat:@"%d", _dayLog.good];
        
        if (_dayLog.comments.length > 0)
            _commentsTextView.text = _dayLog.comments;
    }
}

@end
