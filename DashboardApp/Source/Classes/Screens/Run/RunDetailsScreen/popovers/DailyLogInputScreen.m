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

@interface DailyLogInputScreen () <UITextFieldDelegate>

@end

@implementation DailyLogInputScreen {
    
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UITextField *_goodTextField;
    __weak IBOutlet UITextField *_rejectTextField;
    __weak IBOutlet UITextField *_reworkTextField;
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
    
    if (good == 0 && reject == 0 && rework == 0) {
        [LoadingView showShortMessage:@"Please insert some values!"];
        return;
    }
    
    NSMutableDictionary *log = [NSMutableDictionary dictionary];
    log[@"stepid"] = _process.stepId;
    log[@"processno"] = _process.processNo;
    log[@"operator"] = _process.person;
    log[@"comments"] = @"";
    log[@"status"] = @"tmp";
    log[@"qtyTarget"] = _process.qtyTarget;
    log[@"qtyGood"] = [NSString stringWithFormat:@"%d", good];
    log[@"qtyRework"] = [NSString stringWithFormat:@"%d", rework];
    log[@"qtyReject"] = [NSString stringWithFormat:@"%d", reject];
    
    NSString *json = [self jsonString:log];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] addDailyLog:json forRunFlow:_process.runFlowId completion:^(BOOL success, id response) {
       
        if (success) {
            [LoadingView removeLoading];
            [_delegate newLogAdded:log];
            [self cancelButtonTapped];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Layout

- (void) initLayout {
    
    self.title = _process.processName;
    _targetLabel.text = _process.qtyTarget;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Utils

- (NSString*) jsonString:(NSDictionary*)data {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    if (!jsonData) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
