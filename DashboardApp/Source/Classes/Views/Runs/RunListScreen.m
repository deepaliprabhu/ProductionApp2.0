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

@interface RunListScreen () <RunListViewDelegate>

@end

@implementation RunListScreen {
    
    __weak IBOutlet UICollectionView *_collectionView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Layout

- (void) initLayout {
    
    [_collectionView registerClass:[RunScheduleCell class] forCellWithReuseIdentifier:@"RunScheduleCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunScheduleCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"RunScheduleCell"];
    
    RunListView *list = [RunListView createView];
    list.frame = CGRectMake(9, 90, 635, 667);
    list.delegate = self;
    [list setRunList:[NSMutableArray arrayWithArray:_runsList]];
    [self.view addSubview:list];
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
    
    NSString *week = nil;
    if (indexPath.row == 0)
        week = @"Last week";
    else if (indexPath.row == 1)
        week = @"This week";
    else
        week = @"Next week";
    
    [cell layoutWithWeek:week];
    return cell;
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
    
//    RunViewController *runVC = [RunViewController new];
//    [runVC setRun:[[DataManager sharedInstance] getRunWithId:runId]];
//    [self.navigationController pushViewController:runVC animated:false];
    
    RunDetailsScreen *screen = [RunDetailsScreen new];
    screen.run = [[DataManager sharedInstance] getRunWithId:runId];
    [self.navigationController pushViewController:screen animated:true];
}

@end
