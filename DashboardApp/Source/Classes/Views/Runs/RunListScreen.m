//
//  RunListScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunListScreen.h"
#import "RunListView.h"
#import "RunCommentsScreen.h"
#import "RunDetailsScreen.h"
#import "DataManager.h"
#import "RunScheduleCell.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "NSDate+Utils.h"
#import "UIAlertView+Blocks.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Constants.h"

@interface RunListScreen () <RunListViewDelegate, RunScheduleCellProtocol>

@end

@implementation RunListScreen {
    
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet NSLayoutConstraint *_cancelButtonWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_refreshButtonLeadingConstraint;
    __weak IBOutlet UIView *_navView;
    
    RunListView *_listView;
    
    NSIndexPath *_selectedSlotIndex;
    int _selectedSlotWeek;
    
    NSMutableArray *_lastWeekSlots;
    NSMutableArray *_thisWeekSlots;
    NSMutableArray *_nextWeekSlots;
    
    NSDateFormatter *_formatter;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPickingSlot) name:@"CANCELPICKINGSLOT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kNotificationRunsReceived object:nil];
    
    _formatter = [NSDateFormatter new];
    _formatter.dateFormat = @"yyyy-MM-dd";
    
    [self initLayout];
    
    _lastWeekSlots = [NSMutableArray array];
    _thisWeekSlots = [NSMutableArray array];
    _nextWeekSlots = [NSMutableArray array];
    [self getSchedule];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (void) cancelPickingSlot {
    
    _selectedSlotIndex = nil;
    _selectedSlotWeek = -1;
    [_collectionView reloadData];
    
    _cancelButtonWidthConstraint.constant = 0;
    _refreshButtonLeadingConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [_navView layoutIfNeeded];
    }];
}

- (IBAction) cancelButtonTapped {
    
    [self cancelPickingSlot];
    [_listView setSelectableState:false];
}

- (IBAction) refreshButtonTapped {
    
    [LoadingView showLoading:@"Loading..."];
    [[ServerManager sharedInstance] getRunsList];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RunScheduleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RunScheduleCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSArray *slots = indexPath.row==0 ? _lastWeekSlots : (indexPath.row==1 ? _thisWeekSlots : _nextWeekSlots);
    [cell layoutWithWeek:(int)indexPath.row selectedSlotIndex:_selectedSlotIndex selectedSlotWeek:_selectedSlotWeek slots:slots];
    return cell;
}

#pragma mark - RunScheduleListProtocol

- (void) slotWasSelectedAtIndex:(NSIndexPath*)index forWeek:(int)week {
    
    _selectedSlotWeek = week;
    _selectedSlotIndex = index;
    [_listView setSelectableState:true];
    
    _cancelButtonWidthConstraint.constant = 44;
    _refreshButtonLeadingConstraint.constant = 18;
    [UIView animateWithDuration:0.3 animations:^{
        [_navView layoutIfNeeded];
    }];
}

- (void) fullSlotWasSelected:(NSDictionary *)slot forWeek:(int)week {
    
//    NSString *title = [NSString stringWithFormat:@"RUN %@", slot[@"RUNID"]];
    NSString *message = [NSString stringWithFormat:@"Do you want to close %@ for run %@? This slot will be freed.", slot[@"PROCESS"], slot[@"RUNID"]];
    [UIAlertView showWithTitle:nil message:message cancelButtonTitle:@"Yes" otherButtonTitles:@[@"No"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
       
        if (buttonIndex == 0) {
            
            [LoadingView showLoading:@"Loading..."];
            [[ProdAPI sharedInstance] freeSlotForRun:[slot[@"RUNID"] intValue] onDate:slot[@"SCHEDULED"] forProcess:slot[@"PROCESS"] completion:^(BOOL success, id response) {
              
                if (success) {
                    [LoadingView removeLoading];
                    [self removeSlot:slot inArray:week==1?_thisWeekSlots:_nextWeekSlots];
                    [_collectionView reloadData];
                } else {
                    [LoadingView showShortMessage:@"Error, please try again later!"];
                }
            }];
        }
    }];
}

- (void) removeSlot:(NSDictionary*)slot inArray:(NSMutableArray*)arr {
    
    for (int i=0; i<arr.count;i++) {
        NSDictionary *d = arr[i];
        if ([d[@"PROCESS"] isEqualToString:slot[@"PROCESS"]] && [d[@"RUNID"] isEqualToString:slot[@"RUNID"]]) {
            [arr removeObjectAtIndex:i];
            break;
        }
    }
}

#pragma mark - RunListDelegate

- (void) showCommentsForRun:(Run*)run {
 
    RunCommentsScreen *screen = [[RunCommentsScreen alloc] initWithNibName:@"RunCommentsScreen" bundle:nil];
    screen.run = run;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (void) runSelectedAtIndex:(int)runId {
    
    RunDetailsScreen *screen = [RunDetailsScreen new];
    screen.run = [[DataManager sharedInstance] getRunWithId:runId];
    [self.navigationController pushViewController:screen animated:true];
}

- (void) fillSlotWithRun:(Run*)run {
    
    NSString *process = nil;
    if (_selectedSlotIndex.section == 0)
        process = @"Pick n Place";
    else if (_selectedSlotIndex.section == 1)
        process = @"Testing";
    else if (_selectedSlotIndex.section == 2)
        process = @"Assembly";
    else if (_selectedSlotIndex.section == 3)
        process = @"Inspection";
    else
        process = @"Packing";
    
    if ([self run:[run getRunId] forProcess:process alreadyExistsIn:_selectedSlotWeek==1?_thisWeekSlots:_nextWeekSlots]) {
        [LoadingView showShortMessage:@"This run was already scheduled!"];
        return;
    }
    
    NSDate *date = nil;
    if (_selectedSlotWeek == 1)
        date = [NSDate date];
    else {
        date = [[NSDate date] dateByAddingTimeInterval:3600*24*7];
    }
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [f stringFromDate:[NSDate date]];
    
    int selectedWeek = _selectedSlotWeek;
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] scheduleRun:[run getRunId] onDate:dateString forProcess:process completion:^(BOOL success, id response) {
       
        if (success) {
            
            [LoadingView removeLoading];
            
            f.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDictionary *d = @{@"RUNID":[NSString stringWithFormat:@"%d", [run getRunId]], @"PROCESS":process, @"SCHEDULED":dateString, @"STATUS":@"running", @"DATETIME":[f stringFromDate:[NSDate date]]};
            if (selectedWeek == 1)
                [_thisWeekSlots addObject:d];
            else
                [_nextWeekSlots addObject:d];
            [_collectionView reloadData];
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
        }
    }];
}

#pragma mark - Layout

- (void) initLayout {
    
    [_collectionView registerClass:[RunScheduleCell class] forCellWithReuseIdentifier:@"RunScheduleCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunScheduleCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"RunScheduleCell"];
    
    _listView = [RunListView createView];
    _listView.frame = CGRectMake(9, 90, 635, 667);
    _listView.delegate = self;
    [_listView setRunList:[NSMutableArray arrayWithArray:_runsList]];
    [self.view addSubview:_listView];
}

- (void) getSchedule {
    
    for (Run *r in _runsList) {
        
        [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
           
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        
                        if ([self slot:d canBeAddedFrom:response]) {
                            
                            if ([d[@"STATUS"] isEqualToString:@"running"]) {
                                
                                NSString *dateStr = d[@"SCHEDULED"];
                                NSDate *date = [_formatter dateFromString:dateStr];
                                if ([date isThisWeek]) {
                                    [_thisWeekSlots addObject:d];
                                } else if ([date isNextWeek]) {
                                    [_nextWeekSlots addObject:d];
                                } else if ([date isLastWeek]) {
                                    [_lastWeekSlots addObject:d];
                                }
                            }
                        }
                    }
                }
            }
            [_collectionView reloadData];
        }];
    }
}

- (BOOL) slot:(NSDictionary*)slot canBeAddedFrom:(NSArray*)response {
    
    int running = 0;
    int complete = 0;
    for (NSDictionary *d in response) {
        
        if ([d[@"RUNID"] isEqualToString:slot[@"RUNID"]] && [d[@"PROCESS"] isEqualToString:slot[@"PROCESS"]]) {
            if ([d[@"STATUS"] isEqualToString:@"running"])
                running++;
            else
                complete++;
        }
    }
    
    return running > complete;
}

- (BOOL) run:(int)runId forProcess:(NSString*)process alreadyExistsIn:(NSArray*)arr {
    
    for (NSDictionary *d in arr) {
        
        if ([d[@"RUNID"] intValue] == runId && [d[@"PROCESS"] isEqualToString:process])
            return true;
    }
    
    return false;
}

- (void) refreshData {
 
    [LoadingView removeLoading];
    _runsList = [[DataManager sharedInstance] getRuns]; 
    
    [_lastWeekSlots removeAllObjects];
    [_thisWeekSlots removeAllObjects];
    [_nextWeekSlots removeAllObjects];
    [_collectionView reloadData];
    [self getSchedule];
    
    [_listView setRunList:[NSMutableArray arrayWithArray:_runsList]];
}

@end
