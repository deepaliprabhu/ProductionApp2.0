//
//  ScheduleView.m
//  ProductionMobile
//
//  Created by Andrei Ghidoarca on 19/02/2018.
//  Copyright © 2018 Andrei Ghidoarca. All rights reserved.
//

#import "ScheduleView.h"
#import "LayoutUtils.h"
#import "HourScheduleCell.h"

@interface ScheduleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ScheduleView {
    
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_processedLabel;
    __weak IBOutlet NSLayoutConstraint *_targetLabelLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_processedLabelLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_processedLabelWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_targetLabelWidthConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_targetViewWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_processedViewWidthConstraint;
    
    int _totalHours;
    BOOL _selected;
}

__CREATEVIEW(ScheduleView, @"ScheduleView", 0);

+ (CGFloat) width {
    return 190;
}

+ (CGFloat) height {
    return 45;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [_collectionView registerClass:[HourScheduleCell class] forCellWithReuseIdentifier:@"HourScheduleCell"];
    UINib *cellNib = [UINib nibWithNibName:@"HourScheduleCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"HourScheduleCell"];
}

- (void) layoutScheduleWithData:(NSArray*)times isSelected:(BOOL)s {
    
    _selected = s;
    
    float target = [times[0] floatValue];
    float compl = [times[1] floatValue];
    float interval = 3600.0f;
    float totalWidth = [ScheduleView width];
    
    _totalHours = MAX(ceil(MAX(target, compl)/3600.0f), 8);
    _targetViewWidthConstraint.constant = (target/(_totalHours*interval))*totalWidth;
    _processedViewWidthConstraint.constant = (compl/(_totalHours*interval))*totalWidth;
    
    int processed = [times[2] intValue];
    int goal = [times[3] intValue];
    _processedLabel.text = [NSString stringWithFormat:@"%d", processed];
    _targetLabel.text = [NSString stringWithFormat:@"%d", goal];
    
    float w = [LayoutUtils widthForText:_processedLabel.text withFont:ccFont(@"Roboto-Medium", 11)];
    _processedLabelWidthConstraint.constant = w;
    float processedLeading = MAX(_processedViewWidthConstraint.constant - w, 0);
    _processedLabelLeadingConstraint.constant = processedLeading;
    w = [LayoutUtils widthForText:_targetLabel.text withFont:ccFont(@"Roboto-Medium", 11)];
    _targetLabelWidthConstraint.constant = w;
    float targetLeading = MAX(_targetViewWidthConstraint.constant - w, 0);
    _targetLabelLeadingConstraint.constant = targetLeading;
    
    _targetLabel.alpha = 1;
    _processedLabel.alpha = 1;
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalHours;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([ScheduleView width]/_totalHours, 45);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HourScheduleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HourScheduleCell" forIndexPath:indexPath];
    [cell layoutWithHour:(int)indexPath.row+1 selected:_selected];
    return cell;
}

@end
