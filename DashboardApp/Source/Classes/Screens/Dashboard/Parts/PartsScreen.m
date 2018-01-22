//
//  PartsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PartsScreen.h"
#import "Defines.h"
#import "PartModel.h"
#import "ShortsCell.h"
#import "AlternateShortsCell.h"
#import "LoadingView.h"
#import "Run.h"
#import "DataManager.h"
#import "ProdAPI.h"
#import "RunModel.h"

@interface PartsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PartsScreen {
    
    __weak IBOutlet UITableView *_partsTableView;
    __weak IBOutlet UIView *_partsHolderView;
    __weak IBOutlet UILabel *_vendorLabel;
    __weak IBOutlet UILabel *_partsLabel;
    
    NSMutableArray *_parts;
    NSMutableArray *_shorts;
    
    int _totalRunRequests;
    int _currentRunRequests;
    
    int _currentPartRunRequests;
    int _currentHistoryRequests;
    int _currentAuditRequests;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePartHistory) name:@"UPDATEPARTHISTORY" object:nil];
    
    [self initLayout];
    [self getParts];
}

#pragma mark - Actions

- (void) updatePartHistory {
    
    [_partsTableView reloadData];
    
    _currentHistoryRequests = _currentHistoryRequests + 1;
    [self checkPartsInfo];
}

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shorts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PartModel *p = _shorts[section];
    return 1 + p.alternateParts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        static NSString *identifier2 = @"ShortsCell";
        ShortsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
        }
        
        [cell layoutWithShort:_shorts[indexPath.section]];
        
        return cell;
    }
    else
    {
        static NSString *identifier10 = @"AlternateShortsCell";
        AlternateShortsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier10];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier10 owner:nil options:nil][0];
        }
        
        PartModel *m = _shorts[indexPath.section];
        [cell layoutWithShort:m.alternateParts[indexPath.row-1] isLast:m.alternateParts.count==indexPath.row];
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Layout

- (void) initLayout {
    
    [self addShadowTo:_partsHolderView];
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
    _partsLabel.text = [NSString stringWithFormat:@"PART(%d)", (int)_shorts.count];
}

#pragma mark - Utils

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) getParts {
    
    _parts = [NSMutableArray array];
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    for (Run *run in runs) {
        if (run.isLocked == false)
            _totalRunRequests++;
    }
    
    if (_totalRunRequests > 0) {
        
        [LoadingView showLoading:[NSString stringWithFormat: @"Loading 0/%d", _totalRunRequests]];
        for (Run *run in runs) {
            
            if (run.isLocked == false) {
                [[ProdAPI sharedInstance] getPartsForRun:run.runId withCompletion:^(BOOL success, id response) {
                    
                    if (success) {
                        
                        for (NSDictionary *d in response) {
                            PartModel *p = [PartModel partFrom:d];
                            BOOL alreadyThere = false;
                            for (PartModel *part in _parts) {
                                if ([part.part isEqualToString:p.part]) {
                                    alreadyThere = true;
                                    break;
                                }
                            }
                            
                            if (alreadyThere == false) {
                                p.shortQty = [p.qty intValue]*[run getQuantity];
                                [_parts addObject:p];
                            }
                        }
                    }
                    
                    _currentRunRequests++;
                    [LoadingView showLoading:[NSString stringWithFormat: @"Loading runs\n%d/%d", _currentRunRequests, _totalRunRequests]];
                    if (_currentRunRequests == _totalRunRequests) {
                        
                        [LoadingView removeLoading];
                        [_parts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"part" ascending:true]]];
                        [self getPartsInfo];
                    }
                }];
            }
        }
    }
}

- (void) getPartsInfo {
    
    [LoadingView showLoading:@"Loading data"];
    [self getHistoryForAlternateParts];
    [self getAuditForParts];
    [self getRunsForParts];
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
            [self checkPartsInfo];
        }];
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

- (void) getPurchaseForShorts
{
    for (PartModel *s in _shorts)
    {
        [s getPurchases];
        for (PartModel *a in s.alternateParts)
            [a getPurchases];
    }
}

- (void) getAuditFor:(PartModel*)p {
    
    [[ProdAPI sharedInstance] getAuditHistoryFor:p.part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            p.audit = [PartAuditModel objFrom:response];
            [p.audit computeData];
        }
        
        _currentAuditRequests = _currentAuditRequests + 1;
        [self checkPartsInfo];
    }];
}

- (void) checkPartsInfo {
    
    if (_shorts.count > 0)
        return;
    
    int totalCurrent = _currentPartRunRequests + _currentHistoryRequests + _currentAuditRequests;
    int total = (int)_parts.count + [self numberOfAlternateParts] + [self numberOfAllParts];
    [LoadingView changeTitle:[NSString stringWithFormat:@"Loading data\n%d/%d", totalCurrent, total]];
    
    if (totalCurrent == total) {
        [LoadingView removeLoading];
        [self computeShorts];
    }
}

- (void) computeShorts {
 
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
            s.shortQty = needed;
            s.isHardToGet = p.isHardToGet;
            [_shorts addObject:s];
        }
    }

    [self getPurchaseForShorts];

    [self layoutNumberOfPOs];
    [_partsTableView reloadData];
}

- (int) numberOfAllParts {
    
    int c = 0;
    for (PartModel *s in _parts) {
        c = (int)c+(int)s.alternateParts.count+1;
    }
    
    return c;
}

- (int) numberOfAlternateParts {
    
    int c = 0;
    for (PartModel *s in _parts) {
        c = c+(int)s.alternateParts.count;
    }
    
    return c;
}

@end
