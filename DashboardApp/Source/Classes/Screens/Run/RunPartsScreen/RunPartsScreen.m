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
#import "PurchaseCell.h"
#import "PurchaseModel.h"
#import "RunModel.h"
#import "RunPartCell.h"

const CGFloat kMinTableHeight = 144;

@interface RunPartsScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation RunPartsScreen
{
    __unsafe_unretained IBOutlet UIView *_detailsHolderView;
    __unsafe_unretained IBOutlet UILabel *_seeDetailsLabel;
    
    __unsafe_unretained IBOutlet UICollectionView *_purchasesCollectionView;
    __unsafe_unretained IBOutlet UITableView *_runsTableView;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_runsHolderHeightConstraint;
    __unsafe_unretained IBOutlet UILabel *_noRunsLabel;
    __unsafe_unretained IBOutlet UILabel *_noPurchasesLabel;
    
    __unsafe_unretained IBOutlet UIView *_partsHolderView;
    __unsafe_unretained IBOutlet UIButton *_partsButton;
    __unsafe_unretained IBOutlet UIButton *_shortButton;
    __unsafe_unretained IBOutlet UITableView *_componentsTable;
    __unsafe_unretained IBOutlet UITextField *_searchTextField;
    
    __unsafe_unretained IBOutlet UIView *_historyView;
    __unsafe_unretained IBOutlet UIView *_masonStockView;
    __unsafe_unretained IBOutlet UILabel *_masonStockLabel;
    __unsafe_unretained IBOutlet UILabel *_masonDateLabel;
    __unsafe_unretained IBOutlet UIView *_transitStockView;
    __unsafe_unretained IBOutlet UILabel *_transitStockLabel;
    __unsafe_unretained IBOutlet UILabel *_transitDateLabel;
    __unsafe_unretained IBOutlet UIView *_puneStockView;
    __unsafe_unretained IBOutlet UILabel *_puneStockLabel;
    __unsafe_unretained IBOutlet UILabel *_puneDateLabel;
    __unsafe_unretained IBOutlet UILabel *_partTitleLabel;
    __unsafe_unretained IBOutlet UILabel *_stockLabel;
    
    __unsafe_unretained IBOutlet UILabel *_titleLabel;
    
    NSMutableArray *_visibleObjs;
    NSMutableArray *_shorts;
    NSMutableArray *_parts;
    NSMutableArray *_purchases;
    NSMutableArray *_runs;
    
    BOOL _partsAreSelected;
    
    CGFloat _cost;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    _cost = -1;
    [self initLayout];
    
    _runs = [NSMutableArray array];
    _purchases = [NSMutableArray array];
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

- (IBAction) historyButtonTapped {
    
    
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

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _purchases.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PurchaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchaseCell" forIndexPath:indexPath];
    [cell layoutWith:_purchases[indexPath.row] atIndex:(int)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _runsTableView)
        return _runs.count;
    else
        return _visibleObjs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTableView)
        return 34;
    else
        return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTableView) {
        
        static NSString *identifier = @"RunPartCell";
        RunPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
        }
        
        [cell layoutWith:_runs[indexPath.row] at:(int)indexPath.row];
        
        return cell;
    } else {
        
        static NSString *identifier = @"PartsCell";
        PartsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
        }
        
        [cell layoutWith:_visibleObjs[indexPath.row]];
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTableView) {
        
    } else
        [self layoutWith:_visibleObjs[indexPath.row]];
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
    
    [self layoutTitle];
    
    [_purchasesCollectionView registerClass:[PurchaseCell class] forCellWithReuseIdentifier:@"PurchaseCell"];
    UINib *cellNib = [UINib nibWithNibName:@"PurchaseCell" bundle:nil];
    [_purchasesCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"PurchaseCell"];
    
    [self addShadowTo:_partsHolderView];
    [self addShadowTo:_masonStockView];
    [self addShadowTo:_historyView];
    [self addShadowTo:_puneStockView];
    [self addShadowTo:_transitStockView];
}

- (void) layoutTitle {
    
    if (_cost < 0)
        _titleLabel.text = [NSString stringWithFormat:@"Product %@, Run %ld", _run.productName, (long)_run.runId];
    else
        _titleLabel.text = [NSString stringWithFormat:@"Product %@, Run %ld, BOM %.2f$", _run.productName, (long)_run.runId, _cost];
}

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) layoutWith:(PartModel*)part {
    
    if (part != nil) {
        
        _detailsHolderView.alpha = 1;
        _seeDetailsLabel.alpha = 0;
        
        NSDateFormatter *d = [NSDateFormatter new];
        d.dateFormat = @"MM.dd.yyyy";
        
        _partTitleLabel.text = part.part;
        _stockLabel.text = [NSString stringWithFormat:@"%d", [part totalStock]];
        _masonDateLabel.text = [d stringFromDate:part.recoMasonDate];
        _masonStockLabel.text = part.mason;
        _transitDateLabel.text = [d stringFromDate:part.transitDate];
        _transitStockLabel.text = part.transit;
        _puneDateLabel.text = [d stringFromDate:part.recoPuneDate];
        _puneStockLabel.text = part.pune;
        
        [self getPurchasesFor:part];
        [self getRunsFor:part];
    } else {
        
        _detailsHolderView.alpha = 0;
        _seeDetailsLabel.alpha = 1;
        
        _stockLabel.text = @"-";
        _partTitleLabel.text = @"-";
        _masonDateLabel.text = @"-";
        _masonStockLabel.text = @"-";
        _transitDateLabel.text = @"-";
        _transitStockLabel.text = @"-";
        _puneDateLabel.text = @"-";
        _puneStockLabel.text = @"-";
    }
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
            
            _cost = 0;
            for (PartModel *p in _parts) {
                _cost += [p.qty intValue]*[p.pricePerUnit floatValue];
            }
            [self layoutTitle];
            
            NSString *title = [NSString stringWithFormat:@"Parts (%lu)", (unsigned long)_parts.count];
            [_partsButton setTitle:title forState:UIControlStateNormal];
            
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
            
            NSString *title = [NSString stringWithFormat:@"Shorts (%lu)", (unsigned long)_shorts.count];
            [_shortButton setTitle:title forState:UIControlStateNormal];
            
            [_visibleObjs addObjectsFromArray:_shorts];
            [_componentsTable reloadData];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

- (void) getPurchasesFor:(PartModel*)m {
    
    [_purchases removeAllObjects];
    [_purchasesCollectionView reloadData];
    [LoadingView showLoading:@"Loading..."];
    
    [[ProdAPI sharedInstance] getPurchasesForPart:m.part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            if ([response isKindOfClass:[NSArray class]]) {
                _noPurchasesLabel.alpha = 0;
                [LoadingView removeLoading];
                for (NSDictionary *d in response) {
                    [_purchases addObject:[PurchaseModel objFrom:d]];
                }
                [_purchasesCollectionView reloadData];
            } else {
                _noPurchasesLabel.alpha = 1;
            }
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

- (void) getRunsFor:(PartModel*)m {
    
    [_runs removeAllObjects];
    [_runsTableView reloadData];
    
    [[ProdAPI sharedInstance] getRunsFor:m.part withCompletion:^(BOOL success, id response) {

        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    [_runs addObject:[RunModel objectFrom:d]];
                }
                [_runsTableView reloadData];
            }
        }
        
        if (_runs.count > 0) {
            _noRunsLabel.alpha = 0;
            int c = MIN((int)_runs.count-1, 4);
            _runsHolderHeightConstraint.constant = kMinTableHeight + c*[RunPartCell height];
        } else {
            _noRunsLabel.alpha = 1;
            _runsHolderHeightConstraint.constant = kMinTableHeight;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}

@end
