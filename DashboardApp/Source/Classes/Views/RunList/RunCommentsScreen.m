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

@interface RunCommentsScreen () <AddCommentProtocol>

@end

@implementation RunCommentsScreen
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_noCommentsLabel;
    
    NSMutableArray *_comments;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    [self getComments];
}

#pragma mark - Actions

- (IBAction) addCommentsButtonTapped {
 
    AddCommentScreen *screen = [[AddCommentScreen alloc] initWithNibName:@"AddCommentScreen" bundle:nil];
    screen.run = _run;
    screen.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - AddCommentProtocol

- (void) newCommentAdded:(CommentModel *)comment {
    
    [_comments insertObject:comment atIndex:0];
    [self layoutComments];
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

@end
