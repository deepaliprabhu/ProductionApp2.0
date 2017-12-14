//
//  ReconcileScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 13/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ReconcileScreen.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "LocationReconcileCell.h"

@interface ReconcileScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation ReconcileScreen {
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UITextField *_textField;
    
    int _selectedLocation;
    NSArray *_locations;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 333);
    
    _locations = @[@"MASON", @"LAUSANNE", @"PUNE", @"S2", @"P2"];
    [_tableView reloadData];
}

//MARK: - Actions

- (IBAction) reconcileButtonTapped {
    
    [_textField resignFirstResponder];
    if (_textField.text.length == 0) {
        [LoadingView showShortMessage:@"Invalid quantity!"];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reconcile" message:@"Are you sure you want to reconcile this part?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callReconcileAPI];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:yes];
        [alert addAction:no];
        
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"LocationReconcileCell";
    LocationReconcileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    
    [cell layoutWithLocation:_locations[indexPath.row]];
    if (indexPath.row == _selectedLocation)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    _selectedLocation = (int)indexPath.row;
    [_tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Utils

- (void) callReconcileAPI {
    
    [LoadingView showLoading:@"Loading..."];
    NSString *qty = _textField.text;
    [[ProdAPI sharedInstance] reconcilePart:_part.part atLocation:_locations[_selectedLocation] withQty:qty completion:^(BOOL success, id response) {
        
        if (success) {
            
            ActionModel *a = [ActionModel new];
            a.date = [ActionModel normalizedDateFor:[NSDate date]];
            a.action = @"NEW STOCK";
            a.mode = @"RECONCILE_PARTS";
            a.location = _locations[_selectedLocation];
            a.qty = qty;
            [_part.audit addAction:a];
            [LoadingView removeLoading];
            [self dismissViewControllerAnimated:true completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWACTIONFORAUDITPART" object:nil];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

@end
