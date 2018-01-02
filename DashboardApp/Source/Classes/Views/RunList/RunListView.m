//
//  RunListView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 15/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunListView.h"
#import "UIImage+FontAwesome.h"
#import "UIAlertView+Blocks.h"
#import "LoadingView.h"
#import "ProdAPI.h"
#import "DataManager.h"
#import "Constants.h"

@implementation RunListView
{
    __weak IBOutlet UIButton *_orderButton;
    
    NSMutableArray *_runsArray;
    NSMutableArray *_filteredRunsArray;
    NSMutableArray *_colorsArray;
    
    int _selectedType;
    
    int _currentPriorityRequest;
    int _numberOfPriorityRequests;
}

#pragma mark - View lifecycle

__CREATEVIEW(RunListView, @"RunListView", 0);

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRunOrder) name:kNotificationNewRunOrder object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRunList:(NSMutableArray*)runList {
    
    _runsArray = runList;
    [self initRunColors];
    [self pcbPressed:nil];
}

- (UITableView*)getTableView {
    return _tableView;
}

- (UIView*)getDragView {
    return _dragView;
}

- (Run*)getRunAtLocation:(CGPoint)location {
    
    NSArray *indexPathArray = [_tableView indexPathsForVisibleRows];
    RunListViewCell *firstCell = [_tableView cellForRowAtIndexPath:indexPathArray[0]];
    int locX = location.x+23;
    int locY = location.y+(firstCell.frame.origin.y);
    NSLog(@"location x=%d, y=%d",locX,locY);
    
    for (int i=0; i < indexPathArray.count; ++i) {
        RunListViewCell *cell = [_tableView cellForRowAtIndexPath:indexPathArray[i]];
        NSLog(@"cell location x=%f, y=%f, width=%f, height=%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        if ((locX > cell.frame.origin.x)&&(locX < (cell.frame.origin.x+cell.frame.size.width))&&(locY > cell.frame.origin.y)&&(locY < (cell.frame.origin.y+cell.frame.size.height))) {
            NSLog(@"touch location is within cell");
            Run *run = [cell getRun];
            /*if ([run getCategory] == 0) {
             return nil;
             }*/
            return run;
        }
    }
    return 0;
}

#pragma mark - Actions

- (void) newRunOrder {
    
    [_filteredRunsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:true]]];
    [_tableView reloadData];
}

- (IBAction)closePressed:(id)sender {
    [_delegate closeSelected];
}

- (IBAction)pcbPressed:(id)sender {
    
    _tableView.editing = false;
    _downImageView.frame = CGRectMake((_pcbButton.frame.origin.x+_pcbButton.frame.size.width/2)-_downImageView.frame.size.width/2, _downImageView.frame.origin.y, _downImageView.frame.size.width, _downImageView.frame.size.height);
    [self filterRunsForIndex:0];
    [_delegate selectedRunType:0];
}

- (IBAction)assmPressed:(id)sender {
    
    _tableView.editing = false;
    _downImageView.frame = CGRectMake((_assmButton.frame.origin.x+_assmButton.frame.size.width/2)-_downImageView.frame.size.width/2, _downImageView.frame.origin.y, _downImageView.frame.size.width, _downImageView.frame.size.height);
    [self filterRunsForIndex:1];
    [_delegate selectedRunType:1];
}

- (IBAction)devPressed:(id)sender {
    
    _tableView.editing = false;
    _downImageView.frame = CGRectMake((_devButton.frame.origin.x+_devButton.frame.size.width/2)-_downImageView.frame.size.width/2, _downImageView.frame.origin.y, _downImageView.frame.size.width, _downImageView.frame.size.height);
    [self filterRunsForIndex:2];
}

- (IBAction) changeOrderButtonTapped {
    
    _tableView.editing = true;
    _downImageView.frame = CGRectMake((_orderButton.frame.origin.x+_orderButton.frame.size.width/2)-_downImageView.frame.size.width/2, _downImageView.frame.origin.y, _downImageView.frame.size.width, _downImageView.frame.size.height);
    [self filterRunsForIndex:3];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filteredRunsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"RunListViewCell";
    RunListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        cell.delegate = self;
    }
    [cell setCellData:_filteredRunsArray[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (_selectedType == 3);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (_selectedType == 3);
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.row != destinationIndexPath.row) {
        
        [UIAlertView showWithTitle:nil message:@"Are you sure you want to change the order of these runs?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [self changeOrderFrom:(int)sourceIndexPath.row to:(int)destinationIndexPath.row];
            } else {
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate runSelectedAtIndex:[_filteredRunsArray[indexPath.row] getRunId]];
}

#pragma mark - CellProtocol

- (void) showCommentsForRun:(Run *)r {
    [_delegate showCommentsForRun:r];
}

#pragma mark - Utils

- (void) filterRunsForIndex:(int)index {
    
    _filteredRunsArray = [[NSMutableArray alloc] init];
    _selectedType = index;
    switch (index) {
        case 0: {
            for (int i=0; i < _runsArray.count; ++i) {
                Run *run = _runsArray[i];
                if ([run getCategory] == 0) {
                    [_filteredRunsArray addObject:run];
                }
            }
            [_pcbButton setTitle:[NSString stringWithFormat:@"PCB Line (%lu)",(unsigned long)_filteredRunsArray.count] forState:UIControlStateNormal];
        }
            break;
        case 1: {
            for (int i=0; i < _runsArray.count; ++i) {
                Run *run = _runsArray[i];
                if ([run getCategory] == 1) {
                    [_filteredRunsArray addObject:run];
                }
            }
            [_assmButton setTitle:[NSString stringWithFormat:@"ASSM Line (%lu)",(unsigned long)_filteredRunsArray.count] forState:UIControlStateNormal];
        }
            break;
        case 2: {
            for (int i=0; i < _runsArray.count; ++i) {
                Run *run = _runsArray[i];
                if ([[run getRunType] isEqualToString:@"Development"]) {
                    [_filteredRunsArray addObject:run];
                }
            }
            [_devButton setTitle:[NSString stringWithFormat:@"Development (%lu)",(unsigned long)_filteredRunsArray.count] forState:UIControlStateNormal];
        }
            break;
        case 3: {
            [_filteredRunsArray addObjectsFromArray:_runsArray];
        }
        default:
            break;
    }
    [_tableView reloadData];
}

- (void) initRunColors {
    
    for (int i=0; i < _runsArray.count; ++i) {
        Run *run = _runsArray[i];
        if ([[run getStatus] containsString:@"NEW"]) {
            [run setRunColor:[UIColor grayColor]];
        }
        else if([[run getStatus] containsString:@"ON HOLD"]) {
            [run setRunColor:[UIColor redColor]];
        }
        else {
            [run setRunColor:_colorsArray[i]];
        }
    }
}

- (void) changeOrderFrom:(int)from to:(int)to {
    
    Run *r = _filteredRunsArray[from];
    if (from < to) {
        [_filteredRunsArray insertObject:r atIndex:to+1];
        [_filteredRunsArray removeObjectAtIndex:from];
    } else {
        [_filteredRunsArray insertObject:r atIndex:to];
        [_filteredRunsArray removeObjectAtIndex:from+1];
    }
    
    int start = MIN(from, to);
    _currentPriorityRequest = 0;
    _numberOfPriorityRequests = (int)_filteredRunsArray.count - start;
    for (int i=start; i<_filteredRunsArray.count; i++) {
        
        Run *r  = _filteredRunsArray[i];
        r.order = i+1;
    }
    
    [LoadingView showLoading:@"Loading..."];
    for (int i=start; i<_filteredRunsArray.count; i++) {
        
        Run *r = _filteredRunsArray[i];
        [[ProdAPI sharedInstance] setOrder:(int)r.order forRun:[NSString stringWithFormat:@"%ld", (long)r.runId] withCompletion:^(BOOL success, id response) {
            
            _currentPriorityRequest += 1;
            if (_currentPriorityRequest == _numberOfPriorityRequests) {
                [LoadingView removeLoading];
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                [_runsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:true]]];
                [[DataManager sharedInstance] reorderRuns];
            }
        }];
    }
}

- (void)initView {
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    
    UIImage *iconAdd = [UIImage imageWithIcon:@"fa-plus-circle" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    [_addButton setImage:iconAdd forState:UIControlStateNormal];
    UIImage *iconStats = [UIImage imageWithIcon:@"fa-caret-down" backgroundColor:[UIColor clearColor] iconColor:[UIColor darkGrayColor] fontSize:20];
    
    _downImageView.image = iconStats;
    
    _colorsArray = [[NSMutableArray alloc] init];
    [_colorsArray addObject:[UIColor colorWithRed:166.0f/255.0f green:102.0f/255.0f blue:223.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:0.0f/255.0f green:154.0f/255.0f blue:254.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:151.0f/255.0f green:205.0f/255.0f blue:33.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:93.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:49.0f/255.0f green:203.0f/255.0f blue:205.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:246.0f/255.0f green:182.0f/255.0f blue:112.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:149.0f/255.0f green:49.0f/255.0f blue:222.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:23.0f/255.0f green:161.0f/255.0f blue:98.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:234.0f/255.0f green:89.0f/255.0f blue:82.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:254.0f/255.0f green:213.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:231.0f/255.0f green:100.0f/255.0f blue:133.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:188.0f/255.0f green:191.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:76.0f/255.0f green:139.0f/255.0f blue:245.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:75.0f/255.0f green:112.0f/255.0f blue:125.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:136.0f/255.0f green:180.0f/255.0f blue:2.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:255.0f/255.0f green:180.0f/220.0f blue:0.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:189.0f/255.0f green:239.0f/220.0f blue:240.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:23.0f/255.0f green:155.0f/220.0f blue:230.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:56.0f/255.0f green:118.0f/220.0f blue:118.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:51.0f/255.0f green:115.0f/220.0f blue:172.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:202.0f/255.0f green:124.0f/220.0f blue:203.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:245.0f/255.0f green:121.0f/220.0f blue:54.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:187.0f/255.0f green:202.0f/220.0f blue:127.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:168.0f/255.0f green:196.0f/220.0f blue:238.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:253.0f/255.0f green:77.0f/220.0f blue:73.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:108.0f/255.0f green:141.0f/220.0f blue:91.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:242.0f/255.0f green:100.0f/220.0f blue:35.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:0.0f/255.0f green:122.0f/220.0f blue:255.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:53.0f/255.0f green:61.0f/220.0f blue:125.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:245.0f/255.0f green:96.0f/220.0f blue:120.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:255.0f/255.0f green:163.0f/220.0f blue:31.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:32.0f/255.0f green:164.0f/220.0f blue:100.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:0.0f/255.0f green:160.0f/220.0f blue:220.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:133.0f/255.0f green:44.0f/220.0f blue:38.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:213.0f/255.0f green:83.0f/220.0f blue:62.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:255.0f/255.0f green:167.0f/220.0f blue:33.0f/255.0f alpha:1.0f]];
    [_colorsArray addObject:[UIColor colorWithRed:75.0f/255.0f green:79.0f/220.0f blue:74.0f/255.0f alpha:1.0f]];
}

@end
