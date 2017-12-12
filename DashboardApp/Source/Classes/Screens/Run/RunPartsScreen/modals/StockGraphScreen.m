//
//  StockGraphScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "StockGraphScreen.h"
#import "GridView.h"
#import "StockCell.h"
#import "StockLogScreen.h"

@interface StockGraphScreen () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation StockGraphScreen
{
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UIImageView *_backgroundImageView;
    __weak IBOutlet UIView *_holderView;
    __weak IBOutlet UILabel *_totalLabel;
    __weak IBOutlet UILabel *_totalDateLabel;
    __weak IBOutlet UILabel *_puneLabel;
    __weak IBOutlet UILabel *_masonLabel;
    __weak IBOutlet UILabel *_reconcileLabel;
    __weak IBOutlet UILabel *_runLabel;
    __weak IBOutlet UILabel *_transitLabel;
    __weak IBOutlet UILabel *_noHistoryLabel;
    
    GridView *_gridView;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
    [self computeData];
}

#pragma mark - Actions

- (IBAction) closeButtonTapped {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) enterButtonTapped {
    
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _part.audit.days.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    StockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StockCell" forIndexPath:indexPath];
    [cell layoutWith:_part.audit.days[indexPath.row] maxPos:_part.audit.maxPositive maxNeg:_part.audit.maxNegative];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StockLogScreen *screen = [[StockLogScreen alloc] initWithNibName:@"StockLogScreen" bundle:nil];
    screen.actions = _part.audit.days[indexPath.row][@"actions"];
    
    UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = [collectionView convertRect:theAttributes.frame toView:collectionView.superview.superview];
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:screen];
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:true];
}

#pragma mark - Layout

- (void) initLayout {
    
    _holderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _holderView.layer.shadowOffset = CGSizeMake(2, 2);
    _holderView.layer.shadowRadius = 10;
    _holderView.layer.shadowOpacity = 0.3;
    [self addBlur];
    [self addGrid];
    
    [_collectionView registerClass:[StockCell class] forCellWithReuseIdentifier:@"StockCell"];
    UINib *cellNib = [UINib nibWithNibName:@"StockCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"StockCell"];
}

- (void) addBlur {
    
    _backgroundImageView.image = _image;
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *v = [[UIVisualEffectView alloc] initWithEffect:eff];
    v.frame = _backgroundImageView.bounds;
    v.alpha = 0.9;
    _backgroundImageView.alpha = 0.9;
    
    [_backgroundImageView addSubview:v];
}

- (void) addGrid {
 
    _gridView = [GridView createView];
    _gridView.frame = CGRectMake(0, 141, 644, 330);
    [_holderView insertSubview:_gridView belowSubview:_collectionView];
}

#pragma mark - Utils

- (void) computeData {
    
    [_part.audit computeData];
    
    _noHistoryLabel.alpha = _part.audit.days.count == 0;
    [_collectionView reloadData];
    if (_part.audit.days.count > 0)
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_part.audit.days.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:false];
    
    [self fillContent];
}

- (void) fillContent {
    
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"dd MMM yyyy";
    
    NSDictionary *lastDay = [_part.audit.days lastObject];
    NSDate *d = lastDay[@"date"];
    _totalDateLabel.text = [f stringFromDate:d];
    
    _totalLabel.text = [NSString stringWithFormat: @"%d", [_part totalStock]];
    _puneLabel.text = [NSString stringWithFormat: @"%d", [_part puneStock]];
    _masonLabel.text = [NSString stringWithFormat: @"%d", [_part masonStock]];
    _runLabel.text = [NSString stringWithFormat: @"%d", [lastDay[@"run"] intValue]];
    _reconcileLabel.text = [NSString stringWithFormat: @"%d", [lastDay[@"reco"] intValue]];
    
    [_gridView layoutWithMax:_part.audit.maxPositive min:_part.audit.maxNegative];
}

@end
