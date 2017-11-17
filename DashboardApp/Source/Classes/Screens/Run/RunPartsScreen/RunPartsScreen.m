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
#import "PurchaseModel.h"
#import "RunModel.h"
#import "RunPartCell.h"
#import "PurchasePartCell.h"
#import "PartHistoryScreen.h"
#import "DataManager.h"
#import "PriorityRunCell.h"
#import "UIAlertView+Blocks.h"

const CGFloat kMinTableHeight = 144;

@interface RunPartsScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation RunPartsScreen
{
    __unsafe_unretained IBOutlet UIView *_detailsHolderView;
    __unsafe_unretained IBOutlet UILabel *_seeDetailsLabel;
    
    __unsafe_unretained IBOutlet UITableView *_purchasesTableView;
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
    __unsafe_unretained IBOutlet NSLayoutConstraint *_titleTopConstraint;
    __unsafe_unretained IBOutlet UIView *_bomView;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_bomWidthConstraint;
    __unsafe_unretained IBOutlet UILabel *_bomLabel;
    
    __unsafe_unretained IBOutlet UILabel *_vendorLabel;
    __unsafe_unretained IBOutlet UILabel *_priceLabel;
    
    __unsafe_unretained IBOutlet UIButton *_runsButton;
    __unsafe_unretained IBOutlet UIButton *_prioritiesButton;
    __unsafe_unretained IBOutlet UIView *_runsHeaderView;
    __unsafe_unretained IBOutlet UIView *_prioritiesHeaderView;
    
    NSMutableArray *_visibleObjs;
    NSMutableArray *_shorts;
    NSMutableArray *_parts;
    NSMutableArray *_purchases;
    NSMutableArray *_runs;
    NSMutableArray *_priorityRuns;
    
    BOOL _partsAreSelected;
    BOOL _prioritiesAreSelected;
    
    CGFloat _cost;
    
    __unsafe_unretained PartModel *_visiblePart;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    _cost = -1;
    [self initLayout];
    
    _runs = [NSMutableArray array];
    _purchases = [NSMutableArray array];
    _visibleObjs = [NSMutableArray array];
    _priorityRuns = [NSMutableArray array];
    [self filterPriorityRuns];
    _partsAreSelected = true;
    [self layoutButtons];
    [self getParts];
}

#pragma mark - Actions

- (IBAction) priceButtonTapped {
    
    PartHistoryScreen *screen = [[PartHistoryScreen alloc] initWithNibName:@"PartHistoryScreen" bundle:nil];
    screen.part = _visiblePart;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_priceLabel convertRect:_priceLabel.bounds toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) partsButtonTapped {
    
    _searchTextField.text = @"";
    _partsAreSelected = true;
    _vendorLabel.text = @"VENDOR";
    [self layoutButtons];
    [self getParts];
}

- (IBAction) shortButtonTapped {
    
    _searchTextField.text = @"";
    _partsAreSelected = false;
    _vendorLabel.text = @"OPEN PO";
    [self layoutNumberOfPOs];
    [self layoutButtons];
    [self getShorts];
}

- (IBAction) historyButtonTapped {
    
    
}

- (IBAction) bomButtonTapped {
    
}

- (IBAction) runsButtonTapped {
 
    _prioritiesAreSelected = false;
    _runsButton.titleLabel.font = ccFont(@"Roboto-Regular", 19);
    _prioritiesButton.titleLabel.font = ccFont(@"Roboto-Light", 19);
    
    _runsHeaderView.alpha = 1;
    _prioritiesHeaderView.alpha = 0;
    _runsTableView.editing = false;
    
    [self layoutTableFor:_runs];
    [_runsTableView reloadData];
}

- (IBAction) prioritiesButtonTapped {
    
    _prioritiesAreSelected = true;
    _runsButton.titleLabel.font = ccFont(@"Roboto-Light", 19);
    _prioritiesButton.titleLabel.font = ccFont(@"Roboto-Regular", 19);
    
    _runsHeaderView.alpha = 0;
    _prioritiesHeaderView.alpha = 1;
    _runsTableView.editing = true;
    
    [self layoutTableFor:_priorityRuns];
    [_runsTableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * searchStr = [[textField.text stringByReplacingCharactersInRange:range withString:string] lowercaseString];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
    if (searchStr.length == 0) {
        [_visibleObjs removeAllObjects];
        if (_partsAreSelected == true)
            [_visibleObjs addObjectsFromArray:_parts];
        else
            [_visibleObjs addObjectsFromArray:_shorts];
    } else {
        for (int i=0; i<_visibleObjs.count; i++) {
            PartModel *p = _visibleObjs[i];
            if ([[p.part lowercaseString] containsString:searchStr] == false)
                [set addIndex:i];
        }
        [_visibleObjs removeObjectsAtIndexes:set];
    }
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
    
    if (tableView == _purchasesTableView)
        return _purchases.count;
    else if (tableView == _runsTableView)
    {
        if (_prioritiesAreSelected)
            return _priorityRuns.count;
        else
            return _runs.count;
    }
    else
        return _visibleObjs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTableView || tableView == _purchasesTableView)
        return 34;
    else
        return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _purchasesTableView) {
        
        static NSString *identifier3 = @"PurchasePartCell";
        PurchasePartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil][0];
        }

        [cell layoutWith:_purchases[indexPath.row] atIndex:(int)indexPath.row];
        
        return cell;
    }
    else if (tableView == _runsTableView) {
        
        if (_prioritiesAreSelected)
        {
            static NSString *identifier4 = @"PriorityRunCell";
            PriorityRunCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil][0];
            }
            
            Run *run = _priorityRuns[indexPath.row];
            BOOL c = false;
            for (RunModel *r in _runs) {
                if ([r.runID intValue] == run.runId)
                {
                    c = true;
                    break;
                }
            }
            [cell layoutWith:run at:(int)indexPath.row containsPart:c];
            
            return cell;
        }
        else
        {
            static NSString *identifier1 = @"RunPartCell";
            RunPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil][0];
            }
            
            [cell layoutWith:_runs[indexPath.row] at:(int)indexPath.row];
            
            return cell;
        }
    } else {
        
        static NSString *identifier2 = @"PartsCell";
        PartsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
        }
        
        if (_partsAreSelected)
            [cell layoutWithPart:_visibleObjs[indexPath.row]];
        else
            [cell layoutWithShort:_visibleObjs[indexPath.row]];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (tableView == _runsTableView && _prioritiesAreSelected == true);
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [UIAlertView showWithTitle:nil message:@"Are you sure you want to change the order of these runs?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            Run *r = _priorityRuns[sourceIndexPath.row];
            NSString *rID = [NSString stringWithFormat:@"%ld", (long)r.runId];
            [LoadingView showLoading:@"Loading..."];
            [[ProdAPI sharedInstance] setOrder:(int)destinationIndexPath.row+1 forRun:rID withCompletion:^(BOOL success, id response) {
                
                if (success) {
                    [LoadingView removeLoading];
                    [_priorityRuns exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
                    [_runsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [LoadingView showShortMessage:@"Error, please try again later!"];
                }
            }];
            
        } else {
            [_runsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTableView || tableView == _purchasesTableView) {
        
    } else
        _visiblePart = _visibleObjs[indexPath.row];
        [self layoutWith:_visiblePart];
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
    
    [self addShadowTo:_partsHolderView];
    [self addShadowTo:_masonStockView];
    [self addShadowTo:_historyView];
    [self addShadowTo:_puneStockView];
    [self addShadowTo:_transitStockView];
}

- (void) layoutTitle {
    
    float alpha = 0;
    _titleLabel.text = [NSString stringWithFormat:@"Product %@, Run %ld", _run.productName, (long)_run.runId];
    if (_cost < 0)
    {
        _titleTopConstraint.constant = 20;
        alpha = 0;
        _bomLabel.text = @"-$";
    }
    else
    {
        _titleTopConstraint.constant = 10;
        alpha = 1;
        NSString *bom = [NSString stringWithFormat:@"BOM %.5f$", _cost];
        _bomLabel.text = bom;
        
        CGFloat w = [self widthForText:bom withFont:ccFont(@"Roboto-Bold", 19)];
        _bomWidthConstraint.constant = w;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _bomView.alpha = alpha;
        [self.view layoutIfNeeded];
    }];
}

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) layoutWith:(PartModel*)part {
    
    _runsTableView.editing = false;
    if (part != nil) {
        
        [self runsButtonTapped];
        
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
        _puneStockLabel.text = [NSString stringWithFormat:@"%d", [part totalPune]];
        
        if (part.pricePerUnit == nil)
            _priceLabel.text = @"-$";
        else
            _priceLabel.text = [NSString stringWithFormat:@"%@$", part.pricePerUnit];
        
        [self getPurchasesFor:part];
        [self getRunsFor:part];
    } else {
        
        _detailsHolderView.alpha = 0;
        _seeDetailsLabel.alpha = 1;
        
        _priceLabel.text = @"$-";
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

- (void) layoutNumberOfPOs {
    
    int c = 0;
    for (PartModel *p in _shorts) {
        if (p.po != nil)
            c++;
    }
    
    _vendorLabel.text = [NSString stringWithFormat:@"OPEN PO(%d)", c];
}

- (void) layoutTableFor:(NSArray*)content
{
    if (content.count > 0) {
        _noRunsLabel.alpha = 0;
        float c = MIN((int)content.count-1, 4);
        _runsHolderHeightConstraint.constant = kMinTableHeight + c*[RunPartCell height];
    } else {
        _noRunsLabel.alpha = 1;
        _runsHolderHeightConstraint.constant = kMinTableHeight;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
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
                PartModel *s = [PartModel partFrom:d];
                PartModel *p = [self partWithID:s.part];
                s.shortQty = [p.qty intValue]*[_run getQuantity];
                [_shorts addObject:s];
            }
            
            [self layoutNumberOfPOs];
            
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
    [_purchasesTableView reloadData];
    [LoadingView showLoading:@"Loading..."];
    
    [[ProdAPI sharedInstance] getPurchasesForPart:m.part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
            if ([response isKindOfClass:[NSArray class]]) {
                _noPurchasesLabel.alpha = 0;
                for (NSDictionary *d in response) {
                    [_purchases addObject:[PurchaseModel objFrom:d]];
                }
                [_purchases sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:false]]];
                [_purchasesTableView reloadData];
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
        
        [self layoutTableFor:_runs];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
}

- (CGFloat) widthForText:(NSString*)text withFont:(UIFont*)font
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return ceil(rect.size.width);
}

- (void) filterPriorityRuns
{
    NSArray *runs = [__DataManager getRuns];
//    for (Run *r in runs) {
//        if (([r getCategory] == [_run getCategory]) || ([[r getRunType] isEqualToString:@"Development"] && [[_run getRunType] isEqualToString:@"Development"]))
//            [_priorityRuns addObject:r];
//    }
    [_priorityRuns addObjectsFromArray:runs];
    [_priorityRuns sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"runId" ascending:true]]];
}

- (PartModel*) partWithID:(NSString*)s {
    
    for (PartModel *p in _parts) {
        if ([p.part isEqualToString:s])
            return p;
    }
    
    return nil;
}

@end
