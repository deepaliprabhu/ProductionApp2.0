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
#import "AlternatePartCell.h"
#import "ActionModel.h"
#import "CommentsPartCell.h"
#import "CommentModel.h"
#import "AddCommentScreen.h"
#import "PartDescriptionScreen.h"
#import "LayoutUtils.h"
#import "PODateScreen.h"
#import "StockGraphScreen.h"
#import "UIView+Screenshot.h"

const CGFloat kMinTableHeight = 119;

@interface RunPartsScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddCommentProtocol, PurchaseCellProtocol, PODateScreenDelegate>

@end

@implementation RunPartsScreen
{
    __unsafe_unretained IBOutlet UIView *_detailsHolderView;
    __unsafe_unretained IBOutlet UILabel *_seeDetailsLabel;
    
    __unsafe_unretained IBOutlet UITableView *_commentsTableView;
    __unsafe_unretained IBOutlet UITableView *_purchasesTableView;
    __unsafe_unretained IBOutlet UITableView *_runsTableView;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_runsHolderHeightConstraint;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_purchasesHolderHeightConstraint;
    __unsafe_unretained IBOutlet UILabel *_noRunsLabel;
    __unsafe_unretained IBOutlet UILabel *_noPurchasesLabel;
    __unsafe_unretained IBOutlet UILabel *_noCommentsLabel;
    
    __unsafe_unretained IBOutlet UIView *_partsHolderView;
    __unsafe_unretained IBOutlet UIButton *_partsButton;
    __unsafe_unretained IBOutlet UIButton *_shortButton;
    __unsafe_unretained IBOutlet UITableView *_componentsTable;
    __unsafe_unretained IBOutlet UITextField *_searchTextField;

    __unsafe_unretained IBOutlet NSLayoutConstraint *_transitWidthConstraint;
    __unsafe_unretained IBOutlet UIView *_historyView;
    __unsafe_unretained IBOutlet UIView *_masonStockView;
    __unsafe_unretained IBOutlet UILabel *_masonStockLabel;
    __unsafe_unretained IBOutlet UILabel *_masonDateLabel;
    __unsafe_unretained IBOutlet UILabel *_masonModeLabel;
    __unsafe_unretained IBOutlet UILabel *_puneModeLabel;
    __unsafe_unretained IBOutlet UIView *_transitStockView;
    __unsafe_unretained IBOutlet UILabel *_transitStockLabel;
    __unsafe_unretained IBOutlet UILabel *_transitDateLabel;
    __unsafe_unretained IBOutlet UILabel *_transitIDLabel;
    __unsafe_unretained IBOutlet UIView *_puneStockView;
    __unsafe_unretained IBOutlet UILabel *_puneStockLabel;
    __unsafe_unretained IBOutlet UILabel *_puneDateLabel;
    __unsafe_unretained IBOutlet UILabel *_stockLabel;
    
    __unsafe_unretained IBOutlet UIButton *_partTitleButton;
    __unsafe_unretained IBOutlet NSLayoutConstraint *_partTitleLineWidthConstraint;
    
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
    NSMutableArray *_comments;
    NSMutableArray *_runs;
    NSMutableArray *_priorityRuns;
    
    NSDateFormatter *_formatter;
    
    BOOL _partsAreSelected;
    BOOL _prioritiesAreSelected;
    
    CGFloat _cost;
    
    __unsafe_unretained PartModel *_visiblePart;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePartHistory) name:@"UPDATEPARTHISTORY" object:nil];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"dd MMM yyyy";
    
    _cost = -1;
    [self initLayout];
    
    _runs = [NSMutableArray array];
    _visibleObjs = [NSMutableArray array];
    _priorityRuns = [NSMutableArray array];
    _comments = [NSMutableArray array];
    [self filterPriorityRuns];
    _partsAreSelected = true;
    [self layoutButtons];
    [self getParts];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    [self layoutWith:nil];
    
    _searchTextField.text = @"";
    _partsAreSelected = true;
    _vendorLabel.text = @"VENDOR";
    [self layoutButtons];
    [self getParts];
}

- (IBAction) shortButtonTapped {
    
    [self layoutWith:nil];
    
    _searchTextField.text = @"";
    _partsAreSelected = false;
    _vendorLabel.text = @"OPEN PO";
    [self layoutNumberOfPOs];
    [self layoutButtons];
    [self getShorts];
}

- (IBAction) historyButtonTapped {
    
    StockGraphScreen *screen = [[StockGraphScreen alloc] init];
    screen.part = _visiblePart;
    screen.image = [self.view screenshot];
    screen.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:screen animated:true completion:nil];
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

- (IBAction) addCommentButtonTapped
{
    AddCommentScreen *screen = [[AddCommentScreen alloc] initWithNibName:@"AddCommentScreen" bundle:nil];
    screen.part = _visiblePart;
    screen.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (void) updatePartHistory
{
    [_componentsTable reloadData];
    if (_partsAreSelected == false)
        [self layoutNumberOfPOs];
}

- (IBAction) partTitleButtonTapped
{
    PartDescriptionScreen *screen = [[PartDescriptionScreen alloc] initWithNibName:@"PartDescriptionScreen" bundle:nil];
    screen.partDescription = _visiblePart.partDescription;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect r = _partTitleButton.bounds;
    r.size.width = 2;
    CGRect rect = [_partTitleButton convertRect:r toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
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
    
    if (tableView == _componentsTable)
        return _visibleObjs.count;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _commentsTableView)
        return _comments.count;
    else if (tableView == _purchasesTableView)
        return _visiblePart.purchases.count;
    else if (tableView == _runsTableView)
    {
        if (_prioritiesAreSelected)
            return _priorityRuns.count;
        else
            return _runs.count;
    }
    else
    {
        PartModel *p = _visibleObjs[section];
        return 1 + p.alternateParts.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _commentsTableView)
    {
        CommentModel *c = _comments[indexPath.row];
        return [CommentsPartCell heightFor:c.message offset:0];
    }
    else if (tableView == _runsTableView || tableView == _purchasesTableView)
        return 34;
    else
        return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _commentsTableView) {
     
        static NSString *identifier20 = @"CommentsPartCell";
        CommentsPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier20];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier20 owner:nil options:nil][0];
        }
        
        [cell layoutWith:_comments[indexPath.row] atIndex:(int)indexPath.row];
        
        return cell;
    }
    else if (tableView == _purchasesTableView) {
        
        static NSString *identifier3 = @"PurchasePartCell";
        PurchasePartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil][0];
            cell.delegate = self;
        }

        [cell layoutWith:_visiblePart.purchases[indexPath.row] atIndex:(int)indexPath.row];
        
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
            NSString *q = @"-";
            for (RunModel *r in _runs) {
                if ([r.runID intValue] == run.runId)
                {
                    q = r.qty;
                    break;
                }
            }
            [cell layoutWith:run at:(int)indexPath.row quantity:q];
            
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
        
        if (indexPath.row == 0)
        {
            static NSString *identifier2 = @"PartsCell";
            PartsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
            }
            
            if (_partsAreSelected)
                [cell layoutWithPart:_visibleObjs[indexPath.section]];
            else
                [cell layoutWithShort:_visibleObjs[indexPath.section]];
            
            return cell;
        }
        else
        {
            static NSString *identifier10 = @"AlternatePartCell";
            AlternatePartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier10];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:identifier10 owner:nil options:nil][0];
            }
            
            PartModel *m = _visibleObjs[indexPath.section];
            if (_partsAreSelected)
                [cell layoutWithPart:m.alternateParts[indexPath.row-1] isLast:m.alternateParts.count==indexPath.row];
            else
                [cell layoutWithShort:m.alternateParts[indexPath.row-1] isLast:m.alternateParts.count==indexPath.row];
            
            return cell;
        }
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _runsTableView || tableView == _purchasesTableView || tableView == _commentsTableView) {
        
    }
    else
    {
        PartModel *p = _visibleObjs[indexPath.section];
        if (indexPath.row == 0)
        {
            _visiblePart = p;
            [self layoutWith:_visiblePart];
        }
        else
        {
            _visiblePart = p.alternateParts[indexPath.row-1];
            [self layoutWith:_visiblePart];
        }
    }
}

#pragma mark - PurchaseCellProtocol

- (void) expectedDateButtonTappedAtIndex:(int)index position:(CGRect)rect {
    
    PODateScreen *screen = [[PODateScreen alloc] initWithNibName:@"PODateScreen" bundle:nil];
    screen.purchase = _visiblePart.purchases[index];
    screen.delegate = self;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:true];
}

#pragma mark - AddNewCommentProtocol

- (void) newCommentAdded:(CommentModel *)comment
{
    [_comments insertObject:comment atIndex:0];
    [self layoutComments];
}

#pragma mark - PoDateScreenProtocol

- (void) expectedDateChanged {
    [_purchasesTableView reloadData];
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
        
        CGFloat w = [LayoutUtils widthForText:bom withFont:ccFont(@"Roboto-Bold", 19)];
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
        
        [_partTitleButton setTitle:part.part forState:UIControlStateNormal];
        CGFloat w = [LayoutUtils widthForText:part.part withFont:ccFont(@"Roboto-Regular", 20)];
        _partTitleLineWidthConstraint.constant = w;
        
        _stockLabel.text = [NSString stringWithFormat:@"%d", [part totalStock]];
        
        _masonDateLabel.text = @"";
        _masonModeLabel.text = @"";
        _transitDateLabel.text = [_formatter stringFromDate:part.transitDate];
        
        if (part.transit.length > 0)
        {
            _transitStockLabel.text = part.transit;
            _transitWidthConstraint.constant = 145;
        }
        else
            _transitWidthConstraint.constant = 0;
    
        _puneDateLabel.text = @"";
        _puneModeLabel.text = @"";
        
        if (part.isAlternate) {
            if (part.audit != nil)
                [self layoutAudit];
        } else {
            _masonStockLabel.text = part.mason;
            _puneStockLabel.text = [NSString stringWithFormat:@"%d", [part totalPune]];
        }
        
        if (part.transit.length > 0)
            _transitIDLabel.text = [NSString stringWithFormat:@"ID %@", part.transferID];
        else
            _transitIDLabel.text = @"";
        
        if (part.pricePerUnit == nil)
        {
            if (_visiblePart.priceHistory.count > 0)
                _priceLabel.text = [NSString stringWithFormat:@"%@$", _visiblePart.priceHistory[0][@"PRICE"]];
            else
                _priceLabel.text = @"-$";
        }
        else
            _priceLabel.text = [NSString stringWithFormat:@"%@$", part.pricePerUnit];
        
        [self getPurchasesFor:part];
        [self getRunsFor:part];
        [self getCommentsFor:part];
        [self getAuditFor:part];
    } else {
        
        _detailsHolderView.alpha = 0;
        _seeDetailsLabel.alpha = 1;
        
        _priceLabel.text = @"$-";
        _stockLabel.text = @"-";
        [_partTitleButton setTitle:@"-" forState:UIControlStateNormal];
        _partTitleLineWidthConstraint.constant = 0;
        _masonDateLabel.text = @"-";
        _masonStockLabel.text = @"-";
        _transitDateLabel.text = @"-";
        _transitIDLabel.text = @"ID -";
        _transitStockLabel.text = @"-";
        _puneDateLabel.text = @"-";
        _puneStockLabel.text = @"-";
        _transitWidthConstraint.constant = 145;
    }
    
    [UIView animateWithDuration:0.3 animations:^{ 
        [self.view layoutIfNeeded];
    }];
}

- (void) layoutNumberOfPOs {
    
    int c = 0;
    for (PartModel *p in _shorts) {
        if (p.po != nil)
            c++;
        
        for (PartModel *a in p.alternateParts) {
            if (a.po != nil)
                c++;
        }
    }
    
    _vendorLabel.text = [NSString stringWithFormat:@"OPEN PO(%d)", c];
}

- (void) layoutTableFor:(NSArray*)content
{
    if (content.count > 0) {
        _noRunsLabel.alpha = 0;
        float c = MIN((int)content.count-1, 2);
        _runsHolderHeightConstraint.constant = kMinTableHeight + c*[RunPartCell height];
    } else {
        _noRunsLabel.alpha = 1;
        _runsHolderHeightConstraint.constant = kMinTableHeight;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) layoutPurchasesTable
{
    if (_visiblePart.purchases.count == 0)
    {
        _noPurchasesLabel.alpha = 1;
        _purchasesHolderHeightConstraint.constant = kMinTableHeight;
    }
    else
    {
        float c = MIN((int)_visiblePart.purchases.count-1, 2);
        _purchasesHolderHeightConstraint.constant = kMinTableHeight + c*[RunPartCell height];
        _noPurchasesLabel.alpha = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [_purchasesTableView reloadData];
}

- (void) layoutAudit
{
    ActionModel *a1 = [_visiblePart.audit lastMasonAction];
    if (a1 == nil)
        _masonDateLabel.text = @"";
    else
    {
        _masonDateLabel.text = [_formatter stringFromDate:a1.date];
        _masonModeLabel.text = a1.mode;
        
        if (_visiblePart.isAlternate)
            _masonStockLabel.text = a1.qty;
    }
    
    ActionModel *a2 = [_visiblePart.audit lastPuneAction];;
    if (a2 == nil)
        _puneDateLabel.text = @"";
    else
    {
        _puneDateLabel.text = [_formatter stringFromDate:a2.date];
        _puneModeLabel.text = a2.mode;
        
        if (_visiblePart.isAlternate)
            _puneStockLabel.text = a2.qty;
    }
}

- (void) layoutComments
{
    if (_comments.count == 0)
        _noCommentsLabel.alpha = 1;
    else
        _noCommentsLabel.alpha = 0;
    [_commentsTableView reloadData];
}

#pragma mark - API Utils

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
                [_parts addObject:[PartModel partFrom:d isShort:false]];
            }
            
            _cost = 0;
            for (PartModel *p in _parts) {
                _cost += [p.qty intValue]*[p.pricePerUnit floatValue];
            }
            [self layoutTitle];
            [self getHistoryForAlternateParts];
            [self getAuditForAlternate:_parts];
            
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
                PartModel *s = [PartModel partFrom:d isShort:true];
                PartModel *p = [self partWithID:s.part];
                s.shortQty = [p.qty intValue]*[_run getQuantity];
                [_shorts addObject:s];
            }
            
            [self getAuditForAlternate:_shorts];
            [self getHistoryForShorts];
            [self getPurchaseForShorts];
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
    
    [_purchasesTableView reloadData];
    if (m.purchases == nil) {
        
        [LoadingView showLoading:@"Loading..."];
        [[ProdAPI sharedInstance] getPurchasesForPart:m.part withCompletion:^(BOOL success, id response) {
            
            if (success) {
                [LoadingView removeLoading];
                NSMutableArray *arr = [NSMutableArray array];
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        [arr addObject:[PurchaseModel objFrom:d]];
                    }
                    [arr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:false]]];
                }
                m.purchases = [NSArray arrayWithArray:arr];
            } else {
                [LoadingView showShortMessage:@"Error, try again later!"];
            }
            
            [self layoutPurchasesTable];
        }];
    } else {
        [self layoutPurchasesTable];
    }
}

- (void) getCommentsFor:(PartModel*)m {
    
    [_comments removeAllObjects];
    [_commentsTableView reloadData];
    
    [[ProdAPI sharedInstance] getCommentsForPart:m.part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    [_comments addObject:[CommentModel objectFrom:d]];
                }
                [_comments sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]]];
            }
        } else {
            
        }
        
        [self layoutComments];
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

- (void) getAuditFor:(PartModel*)m {
    
    if (m.audit == nil) {
        
        [[ProdAPI sharedInstance] getAuditHistoryFor:m.part withCompletion:^(BOOL success, id response) {
            
            if (success) {
                m.audit = [PartAuditModel objFrom:response];
                [self layoutAudit];
            }
        }];
    } else {

        [self layoutAudit];
    }
}

- (void) getPurchaseForShorts
{
    for (PartModel *s in _shorts)
    {
        [s getPurchases];
        for (PartModel *a in s.alternateParts)
            [a getPurchases];
    }
}

- (void) getHistoryForShorts {
    
    for (PartModel *s in _shorts) {
        
        [s getHistory];
        for (PartModel *a in s.alternateParts) {
            if (a.priceHistory == nil)
                [a getHistory];
        }
    }
}

- (void) getHistoryForAlternateParts {
    
    for (PartModel *s in _parts) {
        for (PartModel *a in s.alternateParts) {
            if (a.priceHistory == nil)
                [a getHistory];
        }
    }
}

- (void) getAuditForAlternate:(NSArray*)parts {
    
    for (PartModel *s in parts) {
        for (PartModel *a in s.alternateParts) {
            if (a.audit == nil)
            {
                [[ProdAPI sharedInstance] getAuditHistoryFor:a.part withCompletion:^(BOOL success, id response) {
                    
                    if (success) {
                        a.audit = [PartAuditModel objFrom:response];
                        [a.audit computeData];
                        [_componentsTable reloadData];
                    }
                }];
            }
        }
    }
}

#pragma mark - Utils

- (void) filterPriorityRuns {
    
    NSArray *runs = [__DataManager getRuns];
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
