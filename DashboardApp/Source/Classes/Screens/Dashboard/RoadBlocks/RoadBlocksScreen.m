//
//  RoadBlocksScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 14/04/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RoadBlocksScreen.h"
#import "OperatorCell.h"
#import "ProdAPI.h"
#import "LoadingView.h"

@interface RoadBlocksScreen () <UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation RoadBlocksScreen {
    NSMutableArray *_operators;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPersons];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _operators.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"OperatorCell";
    OperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    UserModel *user = _operators[indexPath.row];
    [cell layoutWithPerson:user times:nil selected:false];
    
    return cell;
}

#pragma mark - Utils

- (void) getPersons {
    
    [LoadingView showLoading:@"Loading..."];
    _operators = [NSMutableArray array];
    [[ProdAPI sharedInstance] getPersonsWithCompletion:^(BOOL success, id response) {
        
        if (success) {
            
            [LoadingView removeLoading];
            for (NSDictionary *dict in response) {
                
                UserModel *u = [UserModel objectFromData:dict];
                [_operators addObject:u];
            }
            
            [_operators sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
            [_tableView reloadData];
            
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
