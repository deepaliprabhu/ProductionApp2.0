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
#import "DataManager.h"

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
    statusOptionsArray = [NSMutableArray arrayWithObjects:@"Open", @"In Process",@"On Hold", @"Done",nil];

    [_leftCollectionView reloadData];
    if (processDataArray.count > 0) {
        [_scrollView setContentSize:CGSizeMake(100*processDataArray.count, _scrollView.frame.size.height)];
        //[_collectionView setContentSize:CGSizeMake(100*processDataArray.count, _collectionView.frame.size.height)];
        [_collectionView setFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, 100*processDataArray.count, _collectionView.frame.size.height)];
        [_collectionView reloadData];
        [self setUpProcessTitleView];
    }
}

- (void)setCommonProcessesArray:(NSMutableArray*)commonProcessesArray_ {
    commonProcessesArray = commonProcessesArray_;
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
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"operator"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else if (rowIndex == 1) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[__DataManager getTimeForProcessNo:processData[@"processno"]],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        else if (rowIndex == 2) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"qtyEntered"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (rowIndex == 3) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"qtyOkay"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (rowIndex == 4) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"qtyRework"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (rowIndex == 5) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"qtyReject"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (rowIndex == 6) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"dateAssigned"],@"Title", nil];
            cell.backgroundColor = [UIColor clearColor];
        }
        else if (rowIndex == 7) {
            NSMutableDictionary *processData = processDataArray[colIndex];
            dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:processData[@"dateCompleted"],@"Title", nil];
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
        cell.delegate = self;
        [cell setCellData:dict rowIndex:rowIndex colIndex:colIndex];
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
    processDataArray = [processesArray mutableCopy];
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
        NSMutableDictionary *commonProcessData = [__DataManager getProcessForNo:processData[@"processno"]];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+(i*100), 5, 90, 50)];
        [button setTitle:commonProcessData[@"processname"] forState:UIControlStateNormal];
        button.font = [UIFont systemFontOfSize:10.0f];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.numberOfLines = 3;
        button.layer.cornerRadius = 20.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.clipsToBounds = true;
        button.tag = i;
        [button addTarget:self
                  action:@selector(processButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        if ([processData[@"status"] isEqualToString:@"Done"]) {
            button.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:215.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
        }
        else if ([processData[@"status"] isEqualToString:@"In Process"]) {
            button.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:176.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
        }
        else if ([processData[@"status"] isEqualToString:@"On Hold"]) {
            button.backgroundColor = [UIColor redColor];
        }
        else {
            button.backgroundColor = [UIColor grayColor];
        }
        [_processTitleView addSubview:button];
    }
}

- (IBAction)processButtonClicked:(UIButton*)sender {
    selectedProcessButton = sender;
    dropDownList.tag = 2;
    [self showPopUpWithTitle:@"Set Status" withOption:statusOptionsArray xy:CGPointMake(16, 60) size:CGSizeMake(287, 380) isMultiple:NO];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self animated:YES];
    [dropDownList SetBackGroundDropDown_R:110 G:110.0 B:110.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    switch (anIndex) {
        case 0:{
            selectedProcessButton.backgroundColor = [UIColor grayColor];
            NSMutableDictionary *processData = [processDataArray[selectedProcessButton.tag] mutableCopy];
            processData[@"dateCompleted"] = @"";
            processData[@"status"] = @"Open";
            [_delegate updateProcess:processData];
        }
            break;
        case 1:{
            selectedProcessButton.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:176.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
            selectedProcessButton.backgroundColor = [UIColor grayColor];
            NSMutableDictionary *processData = [processDataArray[selectedProcessButton.tag] mutableCopy];
            processData[@"dateCompleted"] = @"";
            processData[@"status"] = @"In Process";
            [_delegate updateProcess:processData];
        }
            break;
        case 2:{
            selectedProcessButton.backgroundColor = [UIColor redColor];
            selectedProcessButton.backgroundColor = [UIColor grayColor];
            NSMutableDictionary *processData = [processDataArray[selectedProcessButton.tag] mutableCopy];
            processData[@"dateCompleted"] = @"";
            processData[@"status"] = @"On Hold";
            [_delegate updateProcess:processData];
        }
            break;
        case 3:{
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            selectedProcessButton.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:215.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
            NSMutableDictionary *processData = [processDataArray[selectedProcessButton.tag] mutableCopy];
            processData[@"dateCompleted"] = [dateFormat stringFromDate:[NSDate date]];
            processData[@"status"] = @"Done";
            [_delegate updateProcess:processData];
        }
            break;
        default:
            break;
    }
}

- (void)updateProcessWithText:(NSString*)text row:(int)rowIndex col:(int)colIndex {
    NSMutableDictionary *processData = [processDataArray[colIndex] mutableCopy];
    NSLog(@"updating processData:%@",processData);
    switch (rowIndex) {
        case 2:{
            [processData setObject:text forKey:@"qtyEntered"];
        }
            break;
        case 3:{
            [processData setObject:text forKey:@"qtyOkay"];
        }
            break;
        case 4:{
            [processData setObject:text forKey:@"qtyRework"];
        }
            break;
        case 5:{
            [processData setObject:text forKey:@"qtyReject"];
        }
            break;
        case 6:{
            [processData setObject:text forKey:@"dateAssigned"];
        }
            break;
        case 7:{
            [processData setObject:text forKey:@"dateCompleted"];
        }
            break;
        default:
            break;
    }
    NSLog(@"updated ProcessData=%@",processData);
    [processDataArray replaceObjectAtIndex:colIndex withObject:processData];
   // [_delegate updateProcess:processData];
}


@end
