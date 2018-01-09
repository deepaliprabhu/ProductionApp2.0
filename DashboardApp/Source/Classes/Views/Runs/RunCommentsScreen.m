//
//  RunCommentsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunCommentsScreen.h"
#import "CommentsPartCell.h"
#import "CommentModel.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "AddCommentScreen.h"
#import "Defines.h"
#import "UserManager.h"

@interface RunCommentsScreen () <UITextViewDelegate>

@end

@implementation RunCommentsScreen
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noCommentsLabel;
    __weak IBOutlet UITextView *_messageTextView;
    __weak IBOutlet UIView *_holderView;
    
    NSMutableArray *_comments;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    [self getComments];
}

#pragma mark - Actions

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) saveButtonTapped {
    
    [self.view endEditing:true];
    if (_messageTextView.text.length > 0)
    {
        [LoadingView showLoading:@"Loading..."];
        NSString *runID = [NSString stringWithFormat:@"%d", (int)_run.runId];
        [[ProdAPI sharedInstance] addComment:_messageTextView.text forRun:runID from:@"" withCompletion:^(BOOL success, id response) {
            [self commentAddingFinishedWith:success];
        }];
    }
    else
        [LoadingView showShortMessage:@"Please insert a comment"];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CommentModel *c = _comments[indexPath.row];
    return [CommentsPartCell heightFor:c.message offset:(605-522)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier20 = @"CommentsPartCell";
    CommentsPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier20];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier20 owner:nil options:nil][0];
    }
    
    [cell layoutWith:_comments[indexPath.row] atIndex:(int)indexPath.row];
    
    return cell;
}

#pragma mark - Layout

- (void) initLayout
{
    self.title = [_run getFullTitle];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self addShadowTo:_holderView];
}

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) layoutComments {
    
    _noCommentsLabel.alpha = _comments.count == 0;
    [_tableView reloadData];
}

#pragma mark - Utils

- (void) getComments {

    _comments = [NSMutableArray array];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getCommentsForRun:[NSString stringWithFormat:@"%d", (int)_run.runId] withCompletion:^(BOOL success, id response) {
       
        if (success) {
            [LoadingView removeLoading];
            
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    [_comments addObject:[CommentModel objectFrom:d]];
                }
                [_comments sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]]];
            }
            
            [self layoutComments];
        } else {
            _noCommentsLabel.alpha = 1;
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

- (void) commentAddingFinishedWith:(BOOL)success {
    
    if (success)
    {
        _messageTextView.text = @"";
        
        [LoadingView removeLoading];
        CommentModel *c = [CommentModel new];
        c.date = [NSDate date];
        c.author = [[UserManager sharedInstance] loggedUser].username;
        c.message = _messageTextView.text;
        [_comments insertObject:c atIndex:0];
        [self layoutComments];
    }
    else
        [LoadingView showShortMessage:@"Error, please try again later!"];
}

@end
