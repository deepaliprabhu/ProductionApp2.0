//
//  AddCommentScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 23/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "AddCommentScreen.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "Defines.h"

@interface AddCommentScreen () <UITextViewDelegate>
{
    __weak IBOutlet UITextView *_messageTextView;
    __weak IBOutlet UIView *_holderView;
}

@end

@implementation AddCommentScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (void) cancelButtonTapped
{
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) saveButtonTapped
{
    [self.view endEditing:true];
    if (_messageTextView.text.length > 0)
    {
        [LoadingView showLoading:@"Loading..."];
        [[ProdAPI sharedInstance] addComment:_messageTextView.text forPart:_part.part from:@"test@aginova.com" withCompletion:^(BOOL success, id response) {
            
            if (success)
            {
                [LoadingView removeLoading];
                CommentModel *c = [CommentModel new];
                c.date = [NSDate date];
                c.author = @"test@aginova.com";
                c.message = _messageTextView.text;
                [_delegate newCommentAdded:c];
                [self dismissViewControllerAnimated:true completion:false];
            }
            else
                [LoadingView showShortMessage:@"Error, please try again later!"];
        }];
    }
    else
        [LoadingView showShortMessage:@"Please insert a comment"];
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = _part.part;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_messageTextView becomeFirstResponder];
    });
    
    [self addShadowTo:_holderView];
}

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

@end
