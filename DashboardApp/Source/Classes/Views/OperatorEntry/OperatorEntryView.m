//
//  OperatorEntryView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 20/09/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "OperatorEntryView.h"
#import "OperatorTitleCollectionViewCell.h"
#import "OperatorEntryCollectionViewCell.h"

@implementation OperatorEntryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
__CREATEVIEW(OperatorEntryView, @"OperatorEntryView", 0);


- (void)initView {
    titleArray = [NSMutableArray arrayWithObjects:@"Assigned Person",@"Allocated Time", @"Entry Qty",@"Qty Completed",@"Qty Rework",@"Qty Reject",@"Date Assigned", @"Date Completed",nil];
    [_leftCollectionView reloadData];
    if (processDataArray.count > 0) {
        [_scrollView setContentSize:CGSizeMake(100*processDataArray.count, _scrollView.frame.size.height)];
        //[_collectionView setContentSize:CGSizeMake(100*processDataArray.count, _collectionView.frame.size.height)];
        [_collectionView setFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, 100*processDataArray.count, _collectionView.frame.size.height)];
        [_collectionView reloadData];
        [self setUpProcessTitleView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if ([view isEqual:_leftCollectionView]) {
        return 8;
    }
    return processDataArray.count*8;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"OperatorEntryCollectionViewCell";
    static NSString *identifier1 = @"OperatorTitleCollectionViewCell";
    UICollectionViewCell *cell = nil;
    
    if ([collectionView isEqual:_leftCollectionView]) {
        [collectionView registerNib:[UINib nibWithNibName:identifier1 bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier1];
        
        OperatorTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        NSMutableDictionary *dict;
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:235.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:titleArray[indexPath.row],@"Title", nil];
        [cell setCellData:dict rowIndex:0];
        return cell;
    }
    else {
        [collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
        
        OperatorEntryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        int rowIndex = indexPath.row%8;
        int colIndex = indexPath.row/8;
        NSMutableDictionary *dict;
        if (rowIndex == 0) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"op1"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else if (rowIndex == 1) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"time"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else {
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"-",@"Title", nil];
        }
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:235.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        [cell setCellData:dict rowIndex:rowIndex];
        return cell;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)setProcessesArray:(NSMutableArray*)processesArray {
    processDataArray = processesArray;
    [_scrollView setContentSize:CGSizeMake(100*processDataArray.count, _scrollView.frame.size.height)];
    //[_collectionView setContentSize:CGSizeMake(100*processDataArray.count, _collectionView.frame.size.height)];
    [_collectionView setFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, 100*processDataArray.count, _collectionView.frame.size.height)];
    [_collectionView reloadData];
    [self setUpProcessTitleView];
}

- (void)setUpProcessTitleView {
    _processTitleView.frame = CGRectMake(_processTitleView.frame.origin.x, +_processTitleView.frame.origin.y, processDataArray.count*100, _processTitleView.frame.size.height);
    for (int i=0; i < processDataArray.count; ++i) {
        NSMutableDictionary *processData = processDataArray[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5+(i*100), 5, 90, 50)];
        label.text = processData[@"processname"];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 3;
        label.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:176.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
        label.layer.cornerRadius = 20.0f;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        label.layer.borderWidth = 1.0f;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.clipsToBounds = true;
        [_processTitleView addSubview:label];
    }
}


@end
