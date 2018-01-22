//
//  PartsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "PartsScreen.h"
#import "Defines.h"

@interface PartsScreen () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PartsScreen {
    
    __weak IBOutlet UITableView *_partsTableView;
    __weak IBOutlet UIView *_partsHolderView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    if (tableView == _componentsTable)
//        return _visibleObjs.count;
//    else
//        return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    if (tableView == _commentsTableView)
//        return _comments.count;
//    else if (tableView == _purchasesTableView)
//        return _visiblePart.purchases.count;
//    else if (tableView == _runsTableView)
//    {
//        if (_prioritiesAreSelected)
//            return _priorityRuns.count;
//        else
//            return _visiblePart.runs.count;
//    }
//    else
//    {
//        PartModel *p = _visibleObjs[section];
//        return 1 + p.alternateParts.count;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == _commentsTableView)
//    {
//        CommentModel *c = _comments[indexPath.row];
//        return [CommentsPartCell heightFor:c.message offset:0];
//    }
//    else if (tableView == _runsTableView || tableView == _purchasesTableView)
//        return 34;
//    else
//        return 32;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == _commentsTableView) {
//        
//        static NSString *identifier20 = @"CommentsPartCell";
//        CommentsPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier20];
//        if (cell == nil) {
//            cell = [[NSBundle mainBundle] loadNibNamed:identifier20 owner:nil options:nil][0];
//        }
//        
//        [cell layoutWith:_comments[indexPath.row] atIndex:(int)indexPath.row];
//        
//        return cell;
//    }
//    else if (tableView == _purchasesTableView) {
//        
//        static NSString *identifier3 = @"PurchasePartCell";
//        PurchasePartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
//        if (cell == nil) {
//            cell = [[NSBundle mainBundle] loadNibNamed:identifier3 owner:nil options:nil][0];
//            cell.delegate = self;
//        }
//        
//        [cell layoutWith:_visiblePart.purchases[indexPath.row] atIndex:(int)indexPath.row];
//        
//        return cell;
//    }
//    else if (tableView == _runsTableView) {
//        
//        if (_prioritiesAreSelected)
//        {
//            static NSString *identifier4 = @"PriorityRunCell";
//            PriorityRunCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
//            if (cell == nil) {
//                cell = [[NSBundle mainBundle] loadNibNamed:identifier4 owner:nil options:nil][0];
//            }
//            
//            Run *run = _priorityRuns[indexPath.row];
//            NSString *q = @"-";
//            for (RunModel *r in _visiblePart.runs) {
//                if ([r.runID intValue] == run.runId)
//                {
//                    q = r.qty;
//                    break;
//                }
//            }
//            [cell layoutWith:run at:(int)indexPath.row quantity:q];
//            
//            return cell;
//        }
//        else
//        {
//            static NSString *identifier1 = @"RunPartCell";
//            RunPartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
//            if (cell == nil) {
//                cell = [[NSBundle mainBundle] loadNibNamed:identifier1 owner:nil options:nil][0];
//            }
//            
//            [cell layoutWith:_visiblePart.runs[indexPath.row] at:(int)indexPath.row];
//            
//            return cell;
//        }
//    } else {
//        
//        if (indexPath.row == 0)
//        {
//            static NSString *identifier2 = @"PartsCell";
//            PartsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
//            if (cell == nil) {
//                cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
//            }
//            
//            if (_selectedComps == PartsComps)
//                [cell layoutWithPart:_visibleObjs[indexPath.section]];
//            else
//                [cell layoutWithShort:_visibleObjs[indexPath.section]];
//            
//            return cell;
//        }
//        else
//        {
//            static NSString *identifier10 = @"AlternatePartCell";
//            AlternatePartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier10];
//            if (cell == nil) {
//                cell = [[NSBundle mainBundle] loadNibNamed:identifier10 owner:nil options:nil][0];
//            }
//            
//            PartModel *m = _visibleObjs[indexPath.section];
//            if (_selectedComps == PartsComps)
//                [cell layoutWithPart:m.alternateParts[indexPath.row-1] isLast:m.alternateParts.count==indexPath.row];
//            else
//                [cell layoutWithShort:m.alternateParts[indexPath.row-1] isLast:m.alternateParts.count==indexPath.row];
//            
//            return cell;
//        }
//    }
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return true;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleNone;
//}
//
//- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return (tableView == _runsTableView && _prioritiesAreSelected == true);
//}
//
//- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    
//    if (sourceIndexPath.row != destinationIndexPath.row) {
//        
//        [UIAlertView showWithTitle:nil message:@"Are you sure you want to change the order of these runs?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            
//            if (buttonIndex == 1) {
//                
//                [self changeOrderFrom:(int)sourceIndexPath.row to:(int)destinationIndexPath.row];
//            } else {
//                [_runsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }];
//    }
//}
//
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == _runsTableView || tableView == _purchasesTableView || tableView == _commentsTableView) {
//        
//    }
//    else
//    {
//        [self layoutWith:nil];
//        
//        PartModel *p = _visibleObjs[indexPath.section];
//        if (indexPath.row == 0)
//        {
//            _visiblePart = p;
//            [self layoutWith:_visiblePart];
//        }
//        else
//        {
//            _visiblePart = p.alternateParts[indexPath.row-1];
//            [self layoutWith:_visiblePart];
//        }
//    }
//}

#pragma mark - Layout

- (void) initLayout {
    
    [self addShadowTo:_partsHolderView];
}

#pragma mark - Utils

- (void) addShadowTo:(UIView*)v {
    
    v.layer.shadowOffset = ccs(0, 1);
    v.layer.shadowColor = [UIColor blackColor].CGColor;
    v.layer.shadowRadius = 2;
    v.layer.shadowOpacity = 0.2;
}

- (void) getParts {
    
    
}

@end
