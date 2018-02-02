//
//  LoginScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LoginScreen.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "Defines.h"
#import "AppDelegate.h"

@interface LoginScreen () <UITextFieldDelegate>

@end

@implementation LoginScreen {
    
    __weak IBOutlet UITextField *_userTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIButton *_loginButton;
    __weak IBOutlet UIView *_loginHolderView;
    __weak IBOutlet NSLayoutConstraint *_centerVerticalConstraint;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Actions

- (void) keyboardUp {
    
    [UIView animateWithDuration:0.3 animations:^{
        _centerVerticalConstraint.constant = -70;
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardDown {
    
    [UIView animateWithDuration:0.3 animations:^{
        _centerVerticalConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction) loginButtonTapped {
    
    if (_userTextField.text.length == 0) {
        [LoadingView showShortMessage:@"Please insert username"];
    } else if (_passwordTextField.text.length == 0) {
        [LoadingView showShortMessage:@"Please insert password"];
    } else {
     
        [self.view endEditing:true];
        [LoadingView showLoading:@"Loading..."];
        [[UserManager sharedInstance] loginWithUser:_userTextField.text andPassword:_passwordTextField.text withBlock:^(BOOL success) {
          
            if (success) {
                [LoadingView removeLoading];
                [APPDEL goHome];
            }
        }];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _userTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return true;
}

#pragma mark - Layout

- (void) initLayout {
    
//    _userTextField.text = @"guest@aginova.com";
//    _passwordTextField.text = @"guest123";
    
    _userTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    _loginButton.layer.borderWidth = 1;
    _loginButton.layer.borderColor = ccolor(236, 236, 236).CGColor;
}

@end
