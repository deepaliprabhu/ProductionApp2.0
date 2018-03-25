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
#import "Constants.h"
#import "LockConfirmScreen.h"
#import "UserManager.h"
#import "BomHistoryScreen.h"
#import "UserManager.h"
#import "BuyerSelectionScreen.h"

const CGFloat kMinTableHeight = 119;

typedef enum
{
    PartsComps = 0,
    ShortsComps,
    AlShortsComps
} SelectedComps;

@interface RunPartsScreen () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddCommentProtocol, PurchaseCellProtocol, PODateScreenDelegate, PartDescriptionScreenProtocol, BuyerSelectionScreenProtocol>

@end

@implementation RunPartsScreen
{
    __unsafe_unretained IBOutlet UIActivityIndicatorView *_shortsSpinner;
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
    
    __unsafe_unretained IBOutlet UILabel *_vendorPartLabel;
    __unsafe_unretained IBOutlet UILabel *_buyerPartLabel;
    
    __unsafe_unretained IBOutlet UIView *_partsHolderView;
    __unsafe_unretained IBOutlet UIButton *_partsButton;
    __unsafe_unretained IBOutlet UIButton *_shortButton;
    __unsafe_unretained IBOutlet UIButton *_alShortButton;
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
    __unsafe_unretained IBOutlet UILabel *_runTotalQTY;
    
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
    
    __unsafe_unretained IBOutlet UILabel *_lockLabel;
    __unsafe_unretained IBOutlet UIButton *_hardToGetButton;
    
    NSMutableArray *_visibleObjs;
    NSMutableArray *_shorts;
    NSMutableArray *_alShorts;
    NSMutableArray *_parts;
    NSMutableArray *_comments;
    NSMutableArray *_priorityRuns;
    NSArray *_bomValues;
    
    NSDateFormatter *_formatter;
    
    SelectedComps _selectedComps;
    BOOL _prioritiesAreSelected;
    
    CGFloat _cost;
    
    __unsafe_unretained PartModel *_visiblePart;
    
    int _numberOfPriorityRequests;
    int _currentPriorityRequest;
    
    int _currentPartRunRequests;
    int _currentHistoryRequests;
    int _currentAuditRequests;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    _selectedComps = PartsComps;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePartHistory) name:@"UPDATEPARTHISTORY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newActionForAudit) name:@"NEWACTIONFORAUDITPART" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runWasLocked) name:@"RUNWASLOCKED" object:nil];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"dd MMM yyyy";
    
    _cost = -1;
    [self initLayout];
    
    _visibleObjs = [NSMutableArray array];
    _priorityRuns = [NSMutableArray array];
    _comments = [NSMutableArray array];
    [self filterPriorityRuns];
    [self layoutButtons];
    [self getParts];
    [self getBOM];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction) lockButtonTapped {
    
    if ([self runCanBeLocked] == false) {
        [LoadingView showShortMessage:@"This run cannot be locked"];
        return;
    }
    
    LockConfirmScreen *screen = [[LockConfirmScreen alloc] initWithNibName:@"LockConfirmScreen" bundle:nil];
    screen.runParts = _parts;
    screen.run = _run;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction) priceButtonTapped {
    
    PartHistoryScreen *screen = [[PartHistoryScreen alloc] initWithNibName:@"PartHistoryScreen" bundle:nil];
    screen.part = _visiblePart;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_priceLabel convertRect:_priceLabel.bounds toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

- (IBAction) backButtonTapped {
    
    [LoadingView removeLoading];
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction) partsButtonTapped {
    
    [self.view endEditing:true];
    [self layoutWith:nil];
    
    _searchTextField.text = @"";
    _selectedComps = PartsComps;
    _vendorLabel.text = @"VENDOR";
    [self layoutButtons];
    [self getParts];
    
    [self addFooterView];
}

- (IBAction) shortButtonTapped {
    
    [self.view endEditing:true];
    [self layoutWith:nil];
    
    _searchTextField.text = @"";
    _selectedComps = ShortsComps;
    _vendorLabel.text = @"OPEN PO";
    [self layoutNumberOfPOsFor:_shorts];
    [self layoutButtons];
    [self getShorts];
    
    [self addFooterView];
}

- (IBAction) alShortButtonTapped {
    
    [self.view endEditing:true];
    _searchTextField.text = @"";
    _selectedComps = AlShortsComps;
    _vendorLabel.text = @"OPEN PO";
    [self layoutNumberOfPOsFor:_alShorts];
    [self layoutButtons];
    [self getAlShorts];
    
    [self addFooterView];
}

- (IBAction) historyButtonTapped {
    
    StockGraphScreen *screen = [[StockGraphScreen alloc] init];
    screen.part = _visiblePart;
    screen.image = [self.view screenshot];
    screen.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:screen animated:true completion:nil];
}

- (IBAction) bomButtonTapped {
    
    BomHistoryScreen *screen = [[BomHistoryScreen alloc] init];
    screen.bomValues = _bomValues;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:CGRectMake(wScr/2-1, 80, 1, 1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

- (IBAction) runsButtonTapped {
 
    _prioritiesAreSelected = false;
    _runsButton.titleLabel.font = ccFont(@"Roboto-Regular", 19);
    _prioritiesButton.titleLabel.font = ccFont(@"Roboto-Light", 19);
    
    _runsHeaderView.alpha = 1;
    _prioritiesHeaderView.alpha = 0;
    _runsTableView.editing = false;
    
    [self layoutTableFor:_visiblePart.runs];
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

- (void) newActionForAudit {
    
    [_componentsTable reloadData];
    [self layoutWith:_visiblePart];
}

- (void) updatePartHistory {
    _currentHistoryRequests = _currentHistoryRequests + 1;
    [self layoutShortButton];
    
    [_componentsTable reloadData];
    if (_selectedComps == ShortsComps)
        [self layoutNumberOfPOsFor:_shorts];
    else if (_selectedComps == PartsComps)
        [self layoutNumberOfPOsFor:_alShorts];
}

- (void) runWasLocked {
    
    _run.isLocked = true;
    _lockLabel.alpha = _run.isLocked;
    
    _shortButton.alpha = 0;
    _alShortButton.alpha = 0;
    
    _selectedComps = PartsComps;
    
    _cost = -1;
    
    [_parts removeAllObjects];
    [_shorts removeAllObjects];
    [_alShorts removeAllObjects];
    [_visibleObjs removeAllObjects];
    [_comments removeAllObjects];
    
    [self partsButtonTapped];
    [self getBOM];
}

- (IBAction) partTitleButtonTapped
{
    PartDescriptionScreen *screen = [[PartDescriptionScreen alloc] initWithNibName:@"PartDescriptionScreen" bundle:nil];
    screen.delegate = self;
    screen.part = _visiblePart;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect r = _partTitleButton.bounds;
    r.size.width = 2;
    CGRect rect = [_partTitleButton convertRect:r toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

- (IBAction) hardToGetButtonTapped {
    
    BOOL selected = _visiblePart.isHardToGet;
    
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] markHardToGetPart:_visiblePart.part completion:^(BOOL success, id response) {
      
        if (success) {
            [LoadingView removeLoading];
            _visiblePart.isHardToGet = !selected;
            _hardToGetButton.selected = !selected;
            [_componentsTable reloadData];
        } else {
            [LoadingView showLoading:@"Error, please try again later!"];
        }
    }];
}

- (IBAction) buyerButtonTapped {
    
    BuyerSelectionScreen *screen = [[BuyerSelectionScreen alloc] initWithNibName:@"BuyerSelectionScreen" bundle:nil];
    screen.delegate = self;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    CGRect rect = [_buyerPartLabel convertRect:_buyerPartLabel.bounds toView:self.view];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * searchStr = [[textField.text stringByReplacingCharactersInRange:range withString:string] lowercaseString];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
    if (searchStr.length == 0) {
        [_visibleObjs removeAllObjects];
        if (_selectedComps == PartsComps)
            [_visibleObjs addObjectsFromArray:_parts];
        else if (_selectedComps == ShortsComps)
            [_visibleObjs addObjectsFromArray:_shorts];
        else
            [_visibleObjs addObjectsFromArray:_alShorts];
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
    if (_selectedComps == PartsComps)
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
            return _visiblePart.runs.count;
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
            for (RunModel *r in _visiblePart.runs) {
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
            
            [cell layoutWith:_visiblePart.runs[indexPath.row] at:(int)indexPath.row];
            
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
            
            if (_selectedComps == PartsComps)
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
            if (_selectedComps == PartsComps)
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
    
    if (sourceIndexPath.row != destinationIndexPath.row) {
        
        [UIAlertView showWithTitle:nil message:@"Are you sure you want to change the order of these runs?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [self changeOrderFrom:(int)sourceIndexPath.row to:(int)destinationIndexPath.row];
            } else {
                [_runsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _runsTableView || tableView == _purchasesTableView || tableView == _commentsTableView) {
        
    }
    else
    {
        [self layoutWith:nil];
        
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

- (void) expectedDateChangedForPO:(NSString*)po {
    
    [_purchasesTableView reloadData];

    NSString *message = [NSString stringWithFormat:@"changed expected date for PO %@", po];
    NSString *user = [[UserManager sharedInstance] loggedUser].username;
    [[ProdAPI sharedInstance] addComment:message forPart:_visiblePart.part from:user withCompletion:^(BOOL success, id response) {
        
        if (success)
        {
            CommentModel *c = [CommentModel new];
            c.date = [NSDate date];
            c.author = [[UserManager sharedInstance] loggedUser].username;
            c.message = message;
            [self newCommentAdded:c];
        }
    }];
}

#pragma mark - PartDescriptionScreenProtocol

- (void) packageStatusChangeForPart:(PartModel *)part {

    for (PartModel *p in _parts) {
        if ([p.part isEqualToString:part.part])
            p.package = part.package;
    }
    
    for (PartModel *p in _shorts) {
        if ([p.part isEqualToString:part.part])
            p.package = part.package;
    }
    
    [_alShorts removeAllObjects];
    [_componentsTable reloadData];
    if (_selectedComps == AlShortsComps) {
        [self alShortButtonTapped];
    }
}

#pragma mark - BuyerSelectionScreenProtocol

- (void) newBuyerForSelectedPart:(NSString*)buyer {
    
    [LoadingView showLoading:@"Saving"];
    [[ProdAPI sharedInstance] changeBuyerTo:buyer forPart:_visiblePart.part completion:^(BOOL success, id response) {
       
        if (success) {
            [LoadingView removeLoading];
            _visiblePart.buyer = buyer;
            [self setBuyerFor:_visiblePart];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

#pragma mark - Layout

- (void) layoutButtons {
    
    [self layoutDisabled:_partsButton];
    [self layoutDisabled:_shortButton];
    [self layoutDisabled:_alShortButton];
    
    if (_selectedComps == PartsComps) {
        [self layoutEnabled:_partsButton];
    } else if (_selectedComps == ShortsComps) {
        [self layoutEnabled:_shortButton];
    } else {
        [self layoutEnabled:_alShortButton];
    }
}

- (void) layoutDisabled:(UIButton*)btn {
    [btn setTitleColor:ccolor(153, 153, 153) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
}

- (void) layoutEnabled:(UIButton*)btn {
    [btn setTitleColor:ccolor(102, 102, 102) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
}

- (void) initLayout {
    
    _titleLabel.text = [NSString stringWithFormat:@"Product %@, Run %ld", _run.productName, (long)_run.runId];
    
    [self addShadowTo:_partsHolderView];
    [self addShadowTo:_masonStockView];
    [self addShadowTo:_historyView];
    [self addShadowTo:_puneStockView];
    [self addShadowTo:_transitStockView];
    
    _lockLabel.alpha = _run.isLocked;
    _hardToGetButton.alpha = [[[UserManager sharedInstance] loggedUser] isAdmin];

}

- (void) layoutBOM {
    
    if (_bomValues != nil) {
        
        float alpha = 0;
        if (_bomValues.count == 0)
        {
            _titleTopConstraint.constant = 20;
            alpha = 0;
            _bomLabel.text = @"-$";
        }
        else
        {
            _titleTopConstraint.constant = 10;
            alpha = 1;
            NSString *bom = [NSString stringWithFormat:@"BOM %.5f$", [[_bomValues firstObject][@"price"] floatValue]];
            _bomLabel.text = bom;
            
            CGFloat w = [LayoutUtils widthForText:bom withFont:ccFont(@"Roboto-Bold", 19)];
            _bomWidthConstraint.constant = w;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _bomView.alpha = alpha;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) layoutWith:(PartModel*)part {
    
    _priceLabel.text = @"$-";
    _stockLabel.text = @"-";
    _masonDateLabel.text = @"-";
    _masonStockLabel.text = @"-";
    _transitDateLabel.text = @"-";
    _transitIDLabel.text = @"ID -";
    _transitStockLabel.text = @"-";
    _puneDateLabel.text = @"-";
    _puneStockLabel.text = @"-";
    _transitWidthConstraint.constant = 145;
    _runsTableView.editing = false;
    
    if (part != nil) {
        
        [self runsButtonTapped];
        
        _detailsHolderView.alpha = 1;
        _seeDetailsLabel.alpha = 0;
        
        _hardToGetButton.selected = part.isHardToGet;
        
        [_partTitleButton setTitle:part.part forState:UIControlStateNormal];
        CGFloat w = [LayoutUtils widthForText:part.part withFont:ccFont(@"Roboto-Regular", 20)];
        _partTitleLineWidthConstraint.constant = w;
        
        [self layoutAudit];
        _transitDateLabel.text = [_formatter stringFromDate:part.transitDate];
        if (part.transit.length > 0)
        {
            _transitStockLabel.text = part.transit;
            _transitWidthConstraint.constant = 145;
            _transitIDLabel.text = [NSString stringWithFormat:@"ID %@", part.transferID];
        }
        else
        {
            _transitWidthConstraint.constant = 0;
            _transitIDLabel.text = @"";
        }
        
        if (part.pricePerUnit == nil)
        {
            if (_visiblePart.priceHistory.count > 0)
                _priceLabel.text = [NSString stringWithFormat:@"%@$", _visiblePart.priceHistory[0][@"PRICE"]];
            else
                _priceLabel.text = @"-$";
        }
        else
            _priceLabel.text = [NSString stringWithFormat:@"%@$", part.pricePerUnit];
        
        [self getBuyInfoForPart:part];
        [self getPurchasesFor:part];
        [self layoutTotalRunQTYFor:part.runs];
        [self getRunsFor:part];
        [self getCommentsFor:part];
    } else {
        
        _detailsHolderView.alpha = 0;
        _seeDetailsLabel.alpha = 1;
        
        [_partTitleButton setTitle:@"-" forState:UIControlStateNormal];
        _partTitleLineWidthConstraint.constant = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{ 
        [self.view layoutIfNeeded];
    }];
}

- (void) layoutNumberOfPOsFor:(NSArray*)shorts {
    
    int c = 0;
    for (PartModel *p in shorts) {
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
    
    [self layoutTotalRunQTYFor:content];
}

- (void) layoutTotalRunQTYFor:(NSArray*)runs {
    
    if (runs == nil)
        _runTotalQTY.text = @"";
    else {
        int t = 0;
        for (id run in runs) {
            if ([run isKindOfClass:[RunModel class]])
                t += [[run qty] intValue];
            else
                t += [run getQuantity];
        }
        _runTotalQTY.text = [NSString stringWithFormat:@"QTY (%d)", t];
    }
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
        _masonStockLabel.text = a1.qty;
    }
    
    ActionModel *a2 = [_visiblePart.audit lastPuneAction];;
    if (a2 == nil)
        _puneDateLabel.text = @"";
    else
    {
        _puneDateLabel.text = [_formatter stringFromDate:a2.date];
        _puneModeLabel.text = a2.mode;
        _puneStockLabel.text = a2.qty;
    }
    
    _stockLabel.text = [NSString stringWithFormat:@"%d", [_visiblePart totalStock]];
}

- (void) layoutComments
{
    if (_comments.count == 0)
        _noCommentsLabel.alpha = 1;
    else
        _noCommentsLabel.alpha = 0;
    [_commentsTableView reloadData];
}

- (void) addFooterView {
    
    if ([[UserManager sharedInstance] loggedUser].isAdmin == false)
        return;
    
    if (_selectedComps == AlShortsComps) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _componentsTable.bounds.size.width, 70)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 13, _componentsTable.bounds.size.width-30, 44)];
        [btn setTitle:@"Lock" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        btn.backgroundColor = [self runCanBeLocked] ? ccolor(17, 134, 117) : ccgrey;
        [btn addTarget:self action:@selector(lockButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
        _componentsTable.tableFooterView = view;
        
    } else {
        _componentsTable.tableFooterView = nil;
    }
}

- (void) setVendorFor:(PartModel*)part {
    
    if (part.recentVendor) {
        if (part.recentVendor.length > 0)
            _vendorPartLabel.text = part.recentVendor;
        else
            _vendorPartLabel.text = @"-";
    } else {
        _vendorPartLabel.text = @"-";
    }
}


- (void) setBuyerFor:(PartModel*)part {
    
    if (part.buyer) {
        if (part.buyer.length > 0)
            _buyerPartLabel.text = part.buyer;
        else
            _buyerPartLabel.text = @"-";
    } else {
        _buyerPartLabel.text = @"-";
    }
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
    
    if (_run.isLocked == false)
        [_shortsSpinner startAnimating];
    _parts = [NSMutableArray array];
    _shorts = [NSMutableArray array];
    _alShorts = [NSMutableArray array];
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getPartsForRun:_run.runId withCompletion:^(BOOL success, id response) {
        
        if (success) {
            
            [LoadingView removeLoading];
            for (NSDictionary *d in response) {
                PartModel *p = [PartModel partFrom:d];
                p.shortQty = [p.qty floatValue]*[_run getQuantity];
                [_parts addObject:p];
            }
            
            _cost = 0;
            for (PartModel *p in _parts) {
                _cost += [p.qty floatValue]*[p.pricePerUnit floatValue];
            }
            
            [self getHistoryForAlternateParts];
            [self getAuditForParts];
            [self getRunsForParts];
            
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
    for (PartModel *p in _parts) {
        
        int needed = 0;
        for (RunModel *r in p.runs) {
            needed += [r.qty intValue];
        }
        
        NSMutableArray *alternates = [NSMutableArray array];
        int totalStock = [p totalStock];
        if (totalStock < needed) {
            
            for (int i=0; i<p.alternateParts.count; i++) {
                PartModel *alt = p.alternateParts[i];
                int altStock = [alt totalStock];
                totalStock = totalStock + altStock;
                if (totalStock < needed)
                    [alternates addObject:alt];
            }
        }
        
        if (totalStock < needed) {
            
            PartModel *s = [PartModel partFrom:p.data];
            s.alternateParts = alternates;
            s.audit = p.audit;
            s.priceHistory = p.priceHistory;
            s.shortQty = p.shortQty;
            s.isHardToGet = p.isHardToGet;
            [_shorts addObject:s];
        }
    }
    
    [self getPurchaseForShorts];
    NSString *title = [NSString stringWithFormat:@"Shorts (%lu)", (unsigned long)_shorts.count];
    [_shortButton setTitle:title forState:UIControlStateNormal];
    
    [self layoutNumberOfPOsFor:_shorts];
    _alShortButton.alpha = 1;
    
    [_visibleObjs addObjectsFromArray:_shorts];
    [_componentsTable reloadData];
}

- (void) getAlShorts {
    
    [_visibleObjs removeAllObjects];
    [_componentsTable reloadData];
    [self layoutWith:nil];
    
    if (_alShorts.count == 0)
    {
        _alShorts = [NSMutableArray array];
        for (PartModel *p in _shorts) {
            
            if ([p.package isEqualToString:@"yes"])
                continue;
            
            int needed = p.shortQty;
            
            NSMutableArray *alternates = [NSMutableArray array];
            int totalStock = 0;
            if ([_run.location isEqualToString:@"MASON"])
                totalStock = [p masonStock];
            else
                totalStock = [p puneStock];
            if (totalStock < needed) {
                
                for (int i=0; i<p.alternateParts.count; i++) {
                    
                    PartModel *alt = p.alternateParts[i];
                    int altStock = [alt totalStock];
                    totalStock = totalStock + altStock;
                    if (totalStock < needed)
                        [alternates addObject:alt];
                }
            }
            
            if (totalStock < needed) {
                
                PartModel *s = [PartModel partFrom:p.data];
                s.isHardToGet = p.isHardToGet;
                s.purchases = p.purchases;
                s.audit = p.audit;
                s.priceHistory = p.priceHistory;
                s.alternateParts = alternates;
                s.shortQty = p.shortQty;
                [_alShorts addObject:s];
            }
        }
    }
    
    [self layoutNumberOfPOsFor:_alShorts];
    [_visibleObjs addObjectsFromArray:_alShorts];
    [_componentsTable reloadData];
    
    NSString *title = [NSString stringWithFormat:@"Al. Shorts (%lu)", (unsigned long)_alShorts.count];
    [_alShortButton setTitle:title forState:UIControlStateNormal];
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
    
    [_runsTableView reloadData];
    if (m.runs != nil) {
        [self layoutTableFor:m.runs];
        [_runsTableView reloadData];
    } else {
        
        [[ProdAPI sharedInstance] getRunsFor:m.part withCompletion:^(BOOL success, id response) {
            
            NSMutableArray *runs = [NSMutableArray array];
            if (success) {
                
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        [runs addObject:[RunModel objectFrom:d]];
                    }
                }
            }
            m.runs = [NSArray arrayWithArray:runs];
            [_runsTableView reloadData];
            [self layoutTableFor:m.runs];
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
        }];
    }
}

- (void) getRunsForParts {
    
    for (PartModel *p in _parts) {
        
        [[ProdAPI sharedInstance] getRunsFor:p.part withCompletion:^(BOOL success, id response) {
            
            NSMutableArray *runs = [NSMutableArray array];
            if (success) {
                
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        [runs addObject:[RunModel objectFrom:d]];
                    }
                }
            }
            p.runs = [NSArray arrayWithArray:runs];
            
            _currentPartRunRequests = _currentPartRunRequests + 1;
            [self layoutShortButton];
        }];
    }
}

- (void) layoutShortButton {
    
    if (_run.isLocked)
        return;
    
    if (_currentPartRunRequests == _parts.count && _currentHistoryRequests == [self numberOfAlternateParts] && _currentAuditRequests == [self numberOfAllParts]) {
        [_shortsSpinner stopAnimating];
        _shortButton.alpha = 1;
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

- (void) getHistoryForAlternateParts {
    
    for (PartModel *s in _parts) {
        for (PartModel *a in s.alternateParts) {
            if (a.priceHistory == nil)
                [a getHistory];
        }
    }
}

- (void) getAuditForParts {
    
    for (PartModel *s in _parts) {
        [self getAuditFor:s];
        for (PartModel *a in s.alternateParts) {
            if (a.audit == nil)
                [self getAuditFor:a];
        }
    }
}

- (void) getAuditFor:(PartModel*)p {
    
    [[ProdAPI sharedInstance] getAuditHistoryFor:p.part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            p.audit = [PartAuditModel objFrom:response];
            [p.audit computeData];
            [_componentsTable reloadData];
        }
        
        _currentAuditRequests = _currentAuditRequests + 1;
        [self layoutShortButton];
    }];
}

- (void) getBOM {
    
    [[ProdAPI sharedInstance] getBOMForRun:(int)_run.runId completion:^(BOOL success, id response) {
        
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                
                NSDateFormatter *f = [NSDateFormatter new];
                f.dateFormat = @"yyyy-MM-dd HH:mm";
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (NSDictionary *d in response) {
                    
                    NSString *bomID = d[@"BOM_ID"];
                    if (dict[bomID] == nil) {
                        NSString *time = d[@"DATETIME"];
                        NSDictionary *temp = @{@"price": @([d[@"PRICE"] floatValue]), @"time":[f dateFromString:time]};
                        dict[bomID] = temp;
                    } else {
                        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:dict[bomID]];
                        temp[@"price"] = @([temp[@"price"] floatValue] + [d[@"PRICE"] floatValue]);
                        dict[bomID] = temp;
                    }
                }
                
                NSArray *arr = [[dict allValues] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:false]]];
                _bomValues = [NSArray arrayWithArray:arr];
            }
        } else {
            
        }
        
        [self layoutBOM];
    }];
}

- (void) getBuyInfoForPart:(PartModel*)part {
    
    if (part.recentVendor != nil) {
        [self setVendorFor:part];
    } else {
        
        [[ProdAPI sharedInstance] getRecentVendorForPart:part.part completion:^(BOOL success, id response) {
           
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    NSArray *a = (NSArray*)response;
                    if (a.count > 0) {
                        part.recentVendor = [a firstObject][@"Vendor"];
                    }
                }
            }
            [self setVendorFor:part];
        }];
    }
    
    if (part.buyer != nil) {
        [self setBuyerFor:part];
    } else {
        [[ProdAPI sharedInstance] getRecentBuyerForPart:part.part completion:^(BOOL success, id response) {
            
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    NSArray *a = (NSArray*)response;
                    if (a.count > 0) {
                        part.buyer = [a firstObject][@"Buyer"];
                    }
                }
            }
            [self setBuyerFor:part];
        }];
    }
}

#pragma mark - Utils

- (BOOL) runCanBeLocked {
    
    for (PartModel *part in _alShorts) {
        
        if ([part.package isEqualToString:@"yes"] == false)
            return false;
    }
    
    return true;
}

- (void) changeOrderFrom:(int)from to:(int)to {
    
    Run *r = _priorityRuns[from];
    if (from < to) {
        [_priorityRuns insertObject:r atIndex:to+1];
        [_priorityRuns removeObjectAtIndex:from];
    } else {
        [_priorityRuns insertObject:r atIndex:to];
        [_priorityRuns removeObjectAtIndex:from+1];
    }
    
    int start = MIN(from, to);
    _currentPriorityRequest = 0;
    _numberOfPriorityRequests = (int)_priorityRuns.count - start;
    for (int i=start; i<_priorityRuns.count; i++) {
        
        Run *r  = _priorityRuns[i];
        r.order = i+1;
    }
    
    [LoadingView showLoading:@"Loading..."];
    for (int i=start; i<_priorityRuns.count; i++) {
        
        Run *r = _priorityRuns[i];
        [[ProdAPI sharedInstance] setOrder:(int)r.order forRun:[NSString stringWithFormat:@"%ld", (long)r.runId] withCompletion:^(BOOL success, id response) {
            
            _currentPriorityRequest += 1;
            if (_currentPriorityRequest == _numberOfPriorityRequests) {
                [LoadingView removeLoading];
                [_runsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                [[DataManager sharedInstance] reorderRuns];
                __notifyObj(kNotificationNewRunOrder, nil);
//                if (_selectedComps == AlShortsComps) {
//                    [self getAlShorts];
//                } else {
//                    [self computeAlShorts];
//                }
            }
        }];
    }
}

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

- (int) numberOfAlternateParts {
    
    int c = 0;
    for (PartModel *s in _parts) {
        c = c+(int)s.alternateParts.count;
    }
    
    return c;
}

- (int) numberOfAllParts {
    
    int c = 0;
    for (PartModel *s in _parts) {
        c = (int)c+(int)s.alternateParts.count+1;
    }
    
    return c;
}

@end
