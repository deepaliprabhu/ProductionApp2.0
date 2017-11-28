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

@interface RunCommentsScreen ()

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
    
}

- (IBAction) cancelButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
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
    if ([_run getCategory] == 0)
        self.title = [NSString stringWithFormat:@"[PCB] %d: %@",[_run getRunId], [_run getProductName]];
    else
        self.title = [NSString stringWithFormat:@"[ASSM] %d: %@",[_run getRunId], [_run getProductName]];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
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
            
            [_tableView reloadData];
            _noCommentsLabel.alpha = _comments.count == 0;
            
        } else {
            _noCommentsLabel.alpha = 1;
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
