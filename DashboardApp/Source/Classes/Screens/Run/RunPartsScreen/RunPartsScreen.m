//
//  RunPartsScreen.m
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunPartsScreen.h"
#import "ProdAPI.h"
#import "LoadingView.h"
#import "PartModel.h"
#import "PartsCell.h"
#import "Defines.h"

@interface RunPartsScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation RunPartsScreen
{
    __unsafe_unretained IBOutlet UIView *_partsHolderView;
    __unsafe_unretained IBOutlet UIButton *_partsButton;
    __unsafe_unretained IBOutlet UIButton *_shortButton;
    __unsafe_unretained IBOutlet UITableView *_componentsTable;
    __unsafe_unretained IBOutlet UITextField *_searchTextField;
    
    NSMutableArray *_visibleObjs;
    NSMutableArray *_shorts;
    NSMutableArray *_parts;
    
    BOOL _partsAreSelected;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    [self initLayout];
    
    _visibleObjs = [NSMutableArray array];
    _partsAreSelected = true;
    [self layoutButtons];
    [self getParts];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) partsButtonTapped {
    
    _searchTextField.text = @"";
    _partsAreSelected = true;
    [self layoutButtons];
    [self getParts];
}

- (IBAction) shortButtonTapped {
    
    _searchTextField.text = @"";
    _partsAreSelected = false;
    [self layoutButtons];
    [self getShorts];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0; i<_visibleObjs.count; i++) {
        PartModel *p = _visibleObjs[i];
        if ([p.part containsString:searchStr] == false)
            [set addIndex:i];
    }
    [_visibleObjs removeObjectsAtIndexes:set];
    [_componentsTable reloadData];
    
    return true;
}

-  (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [_visibleObjs removeAllObjects];
    if (_partsAreSelected)
        [_visibleObjs addObjectsFromArray:_parts];
    else
        [_visibleObjs addObjectsFromArray:_shorts];
    [_componentsTable reloadData];
    return true;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _visibleObjs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PartsCell";
    PartsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }

    [cell layoutWith:_visibleObjs[indexPath.row]];
    
    return cell;
}

#pragma mark - Layout

- (void) layoutButtons {
    
    if (_partsAreSelected == true) {
        [_partsButton setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
        _partsButton.backgroundColor = [UIColor whiteColor];
        [_shortButton setTitleColor:ccolor(153, 153, 153) forState:UIControlStateNormal];
        _shortButton.backgroundColor = [UIColor clearColor];
    } else {
        [_shortButton setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
        _shortButton.backgroundColor = [UIColor whiteColor];
        [_partsButton setTitleColor:ccolor(153, 153, 153) forState:UIControlStateNormal];
        _partsButton.backgroundColor = [UIColor clearColor];
    }
}

- (void) initLayout {
    
    _partsHolderView.layer.shadowOffset = ccs(0, 1);
    _partsHolderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _partsHolderView.layer.shadowRadius = 2;
    _partsHolderView.layer.shadowOpacity = 0.2;
}

#pragma mark - Utils

- (void) getParts {
    
    [_visibleObjs removeAllObjects];
    [_componentsTable reloadData];
    if (_parts.count > 0) {
        [_visibleObjs addObjectsFromArray:_parts];
        [_componentsTable reloadData];
        return;
    }
    
    _parts = [NSMutableArray array];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getPartsForRun:_run.runId withCompletion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
            for (NSDictionary *d in response) {
                [_parts addObject:[PartModel partFrom:d]];
            }
            [_visibleObjs addObjectsFromArray:_parts];
            [_componentsTable reloadData];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

- (void) getShorts {
    
    [_visibleObjs removeAllObjects];
    [_componentsTable reloadData];
    if (_shorts.count > 0)
    {
        [_visibleObjs addObjectsFromArray:_shorts];
        [_componentsTable reloadData];
        return;
    }
    
    _shorts = [NSMutableArray array];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getShortsForRun:_run.runId withCompletion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
            for (NSDictionary *d in response) {
                [_shorts addObject:[PartModel partFrom:d]];
            }
            [_visibleObjs addObjectsFromArray:_shorts];
            [_componentsTable reloadData];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

@end
