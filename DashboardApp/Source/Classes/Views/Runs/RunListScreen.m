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

@interface RunListScreen () <RunListViewDelegate, RunScheduleCellProtocol>

@end

@implementation RunListScreen {
    
    __weak IBOutlet UICollectionView *_collectionView;
    RunListView *_listView;
    
    NSIndexPath *_selectedSlotIndex;
    int _selectedSlotWeek;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPickingSlot) name:@"CANCELPICKINGSLOT" object:nil];
    
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

- (void) cancelPickingSlot {
    
    _selectedSlotIndex = nil;
    _selectedSlotWeek = -1;
    [_collectionView reloadData];
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
    [cell layoutWithWeek:(int)indexPath.row selectedSlotIndex:_selectedSlotIndex selectedSlotWeek:_selectedSlotWeek];
    return cell;
}

#pragma mark - RunScheduleListProtocol

- (void) slotWasSelectedAtIndex:(NSIndexPath*)index forWeek:(int)week {
    _selectedSlotWeek = week;
    _selectedSlotIndex = index;
    [_listView setSelectableState:true];
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
    
}

@end
