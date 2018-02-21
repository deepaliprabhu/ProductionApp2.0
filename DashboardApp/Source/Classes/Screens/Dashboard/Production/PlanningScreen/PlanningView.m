//
//  PlanningView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 20/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PlanningView.h"
#import "RunTargetCell.h"
#import "Run.h"
#import "DataManager.h"

@implementation PlanningView {
    
    __weak IBOutlet UICollectionView *_runsCollection;
    
    int _selectedRunIndex;
    NSArray *_runs;
}

__CREATEVIEW(PlanningView, @"PlanningView", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_runsCollection registerClass:[RunTargetCell class] forCellWithReuseIdentifier:@"RunTargetCell"];
    UINib *cellNib = [UINib nibWithNibName:@"RunTargetCell" bundle:nil];
    [_runsCollection registerNib:cellNib forCellWithReuseIdentifier:@"RunTargetCell"];
}

- (void) reloadData {
    
    _runs = [[[DataManager sharedInstance] getRuns] sortedArrayUsingComparator:^NSComparisonResult(Run *obj1, Run *obj2) {
        return [obj1 getRunId] > [obj2 getRunId];
    }];
    [_runsCollection reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _runs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RunTargetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RunTargetCell" forIndexPath:indexPath];
    
    int row = (int)indexPath.row;
    Run *run = _runs[row];
    [cell layoutWithRun:[run getRunId] isSelected:row==_selectedRunIndex isFirst:row==0 isLast:row==_runs.count-1];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedRunIndex = (int)indexPath.row;
    [_runsCollection reloadData];
}


@end
