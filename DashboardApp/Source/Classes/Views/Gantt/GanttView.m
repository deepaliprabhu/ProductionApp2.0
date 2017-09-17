//
//  GanttView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 24/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "GanttView.h"
#import "CollectionViewCell.h"
#import "LeftCollectionViewCell.h"
#import "Run.h"

@implementation GanttView

__CREATEVIEW(GanttView, @"GanttView", 0);

- (void)initView {
    stationsArray = [NSMutableArray arrayWithObjects:@"",@"0-NonLine Process",@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding",nil];
    [self thisWeekArray];
    [_collectionView reloadData];
    [_leftCollectionView reloadData];
    //[_tableView reloadData];
}

- (void)setRunType:(int)type {
    if (type == 0) {
        stationsArray = [NSMutableArray arrayWithObjects:@"",@"0-NonLine Process",@"1-Pick N Place", @"2-ThroughHole Assembly",@"3-Inspection",@"4-Cleaning",@"5-Ready For Dispatch" ,@"6-Dispatched",nil];
    }
    else {
        stationsArray = [NSMutableArray arrayWithObjects:@"",@"0-NonLine Process",@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding",nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if ([view isEqual:_leftCollectionView]) {
        return 8;
    }
    return 139;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"CollectionViewCell";
    static NSString *identifier1 = @"LeftCollectionViewCell";
    UICollectionViewCell *cell = nil;

    if ([collectionView isEqual:_leftCollectionView]) {
        [collectionView registerNib:[UINib nibWithNibName:identifier1 bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier1];

        LeftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        NSMutableDictionary *dict;
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor clearColor];
        }
        else {
            if (indexPath.row%2==0) {
                cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:235.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
            }
            else {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stationsArray[indexPath.row],@"Title", nil];
        [cell setCellData:dict rowIndex:0];
        return cell;
    }
    else {
        [collectionView registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];

        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        int rowIndex = indexPath.row%8;
        NSMutableDictionary *dict;
        if (rowIndex == 0) {
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:datesArray[indexPath.row/8],@"RunId", nil];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else {
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"RunId", nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2==0) {
        return 25;
    }
    return 28;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    cell.textLabel.text = stationsArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
    }
    else {
        if (indexPath.row%2 !=0) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:231.0f/255.0f green:235.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        }
    }
    return cell;
}

- (void)thisWeekArray {
    datesArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    int startDate, endDate;
    
    [cal rangeOfUnit:NSMonthCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval];
    startDate = [[dateFormat stringFromDate:startOfTheWeek] intValue];
    endDate = [[dateFormat stringFromDate:endOfWeek] intValue];
    [dateFormat setDateFormat:@"dd/MM"];
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
    NSComparisonResult startCompare = [startOfTheWeek compare: endOfWeek];
    int i=0;
    NSDate *weekDate;
    while((startCompare == NSOrderedAscending)&&(startCompare != NSOrderedSame)) {
        weekDate = [startOfTheWeek dateByAddingTimeInterval:24*60*60*i];
        [datesArray addObject:[dateFormat stringFromDate:weekDate]];
        startCompare = [weekDate compare: endOfWeek];
        NSLog(@"week array = %@",datesArray);
        i++;
    }
    
    NSLog(@"start date = %d, end date= %d",startDate,endDate);
}

- (void)setCellWithRun:(Run*)run andLocation:(CGPoint)location {
    NSLog(@"run id=%d",[run getRunId]);
    int locX = location.x-186;
    int locY = location.y-26;
    NSLog(@"locX =%d, locY=%d",locX, locY);
    NSArray *indexPathArray = [_collectionView indexPathsForVisibleItems];
    CollectionViewCell *firstCell = [_collectionView cellForItemAtIndexPath:indexPathArray[0]];
    for (int i=0; i < indexPathArray.count; ++i) {
        CollectionViewCell *cell = (CollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSLog(@"cell location x=%f, y=%f, width=%f, height=%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        if ((locX > cell.frame.origin.x)&&(locX < (cell.frame.origin.x+cell.frame.size.width))&&(locY > cell.frame.origin.y)&&(locY < (cell.frame.origin.y+cell.frame.size.height))) {
            NSLog(@"touch location is within cell with index=%d",i);
            NSMutableDictionary*dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId", nil];
           // [cell setCellData:dict rowIndex:1];
            [cell addRun:run];
            //cell.backgroundColor = [run getRunColor];
            break;
        }
    }
}

- (void)setCellWithView:(UIView*)view atLocation:(CGPoint)location{
    int locX = location.x-186;
    int locY = location.y-26;
    NSLog(@"locX =%d, locY=%d",locX, locY);
    NSArray *indexPathArray = [_collectionView indexPathsForVisibleItems];
    CollectionViewCell *firstCell = [_collectionView cellForItemAtIndexPath:indexPathArray[0]];
    for (int i=0; i < indexPathArray.count; ++i) {
        CollectionViewCell *cell = (CollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSLog(@"cell location x=%f, y=%f, width=%f, height=%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        if ((locX > cell.frame.origin.x)&&(locX < (cell.frame.origin.x+cell.frame.size.width))&&(locY > cell.frame.origin.y)&&(locY < (cell.frame.origin.y+cell.frame.size.height))) {
            NSLog(@"touch location is within cell with index=%d",i);
            [cell setMovableView:view];
            //cell.backgroundColor = [run getRunColor];
            break;
        }
    }
}

- (UIView*)getViewAtLocation:(CGPoint)location {
    int locX = location.x;
    int locY = location.y;
    NSLog(@"locX =%d, locY=%d",locX, locY);
    NSArray *indexPathArray = [_collectionView indexPathsForVisibleItems];
    CollectionViewCell *firstCell = [_collectionView cellForItemAtIndexPath:indexPathArray[0]];
    for (int i=0; i < indexPathArray.count; ++i) {
        CollectionViewCell *cell = (CollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSLog(@"cell location x=%f, y=%f, width=%f, height=%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        if ((locX > cell.frame.origin.x)&&(locX < (cell.frame.origin.x+cell.frame.size.width))&&(locY > cell.frame.origin.y)&&(locY < (cell.frame.origin.y+cell.frame.size.height))) {
            NSLog(@"touch location is within cell with index=%d",i);
            return [cell getMovableView];
            break;
        }
    }
    return nil;
}

- (UIView*)getDragView {
    return _dragView;
}

- (void)clearViewAtLocation:(CGPoint)location {
    int locX = location.x;
    int locY = location.y;
    NSLog(@"locX =%d, locY=%d",locX, locY);
    NSArray *indexPathArray = [_collectionView indexPathsForVisibleItems];
    CollectionViewCell *firstCell = [_collectionView cellForItemAtIndexPath:indexPathArray[0]];
    for (int i=0; i < indexPathArray.count; ++i) {
        CollectionViewCell *cell = (CollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        NSLog(@"cell location x=%f, y=%f, width=%f, height=%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        if ((locX > cell.frame.origin.x)&&(locX < (cell.frame.origin.x+cell.frame.size.width))&&(locY > cell.frame.origin.y)&&(locY < (cell.frame.origin.y+cell.frame.size.height))) {
            NSLog(@"touch location is within cell with index=%d",i);
            [cell clearMovableView];
            break;
        }
    }
}

- (void)setStationsArrayForRunType:(int)type {
    if (type == 0) {
        stationsArray = [NSMutableArray arrayWithObjects:@"",@"0-NonLine Process",@"1-Pick N Place", @"2-ThroughHole Assembly",@"3-Inspection",@"4-Cleaning",@"5-Ready For Dispatch" ,@"6-Dispatched",nil];
    }
    else {
        stationsArray = [NSMutableArray arrayWithObjects:@"",@"0-NonLine Process",@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding",nil];
    }
    [_leftCollectionView reloadData];
}

- (void)clearData {
    NSArray *indexPathArray = [_collectionView indexPathsForVisibleItems];
    for (int i=0; i < indexPathArray.count; ++i) {
        CollectionViewCell *cell = (CollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cell reloadInputViews];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
