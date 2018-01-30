//
//  OperatorsPickerScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 30/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorsPickerScreen.h"

@interface OperatorsPickerScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OperatorsPickerScreen {
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    float h = MIN((_operators.count+1)*44, 616);
    self.preferredContentSize = CGSizeMake(320, h);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _operators.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"OperatorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0)
        cell.textLabel.text = @"None";
    else {
        UserModel *u = _operators[indexPath.row-1];
        cell.textLabel.text = u.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 0)
        [_delegate operatorChangedTo:nil];
    else
        [_delegate operatorChangedTo:_operators[indexPath.row-1]];
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
