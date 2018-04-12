//
//  BuyerSelectionScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/03/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "BuyerSelectionScreen.h"

@interface BuyerSelectionScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BuyerSelectionScreen
{
    NSArray *_buyers;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_forLocation)
        _buyers = @[@"Mason", @"Lausanne", @"Customer"];
    else
        _buyers = @[@"arvind@aginova.com", @"ashok@aginova.com", @"elizabeth@aginova.com"];
    self.preferredContentSize = CGSizeMake(320, 132);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _buyers.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BuyerCell"];
    }
    
    cell.textLabel.text = _buyers[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_delegate newBuyerForSelectedPart:_buyers[indexPath.row]];
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
