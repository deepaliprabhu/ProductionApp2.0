//
//  ProductionOverview.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionOverview.h"
#import "Defines.h"
#import "ProductionProcessCell.h"
#import "DataManager.h"
#import "Run.h"
#import "ProdAPI.h"
#import "NSDate+Utils.h"

@implementation ProductionOverview {
    
    __weak IBOutlet UIButton *_targetButton;
    __weak IBOutlet UITableView *_runsTable;
    __weak IBOutlet UITableView *_processesTable;
    
    NSMutableArray *_processes;
    NSMutableArray *_runs;
}

__CREATEVIEW(ProductionOverview, @"ProductionOverview", 0)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    _targetButton.layer.masksToBounds = true;
    _targetButton.layer.cornerRadius  = 6;
    _targetButton.layer.borderWidth   = 1;
    _targetButton.layer.borderColor   = ccolor(102, 102, 102).CGColor;
    
    [self computeRuns];
}

#pragma mark - Actions

- (IBAction) targetButtonTapped {
    [_delegate goToTargets];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _runsTable) {
        return _runs.count;
    } else {
        return _processes.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _runsTable) {
        
        static NSString *identifier = @"ProductionRunCell";
        ProductionRunCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
            cell.delegate = self;
        }
        
        [cell layoutWithRun:_runs[indexPath.row]];
        
        return cell;
        
    } else {
        
        static NSString *identifier2 = @"ProductionProcessCell";
        ProductionProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier2 owner:nil options:nil][0];
        }
        
        return cell;
    }
}

#pragma mark - CellProtocol

- (void) showDetailsForRun:(Run*)run {
    [_delegate showDetailsForRun:run];
}

#pragma mark - Utils

- (void) computeRuns {
    
    _runs = [NSMutableArray array];
    
    NSDateFormatter *f = [NSDateFormatter new];
    f = [NSDateFormatter new];
    f.dateFormat = @"yyyy-MM-dd";
    
    NSArray *runs = [[DataManager sharedInstance] getRuns];
    for (Run *r in runs) {
        
        [[ProdAPI sharedInstance] getSlotsForRun:[r getRunId] completion:^(BOOL success, id response) {
            
            if (success) {
                if ([response isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in response) {
                        
                        if ([d[@"STATUS"] isEqualToString:@"running"]) {
                            
                            NSString *dateStr = d[@"SCHEDULED"];
                            NSDate *date = [f dateFromString:dateStr];
                            if ([date isThisWeek]) {
                                [_runs addObject:r];
                                break;
                            }
                        }
                    }
                }
            }
            
            [_runsTable reloadData];
        }];
    }
}

@end
