//
//  OverviewView.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "OverviewView.h"
#import "UIImage+FontAwesome.h"
#import "ProductModel.h"
#import "Run.h"
#import "LayoutUtils.h"
#import "ProdAPI.h"
#import "DayLogModel.h"
#import "NSDate+Utils.h"

@implementation OverviewView {
    
    __weak IBOutlet UILabel *_roadBlocksLabel;
    __weak IBOutlet UILabel *_productionProcessesLabel;
    __weak IBOutlet UILabel *_productionTargetsLabel;
    __weak IBOutlet NSLayoutConstraint *_processesLabelWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_targetsLabelWidthConstraint;
}
__CREATEVIEW(OverviewView, @"OverviewView", 0);

- (void)initView {
    
    UIImage *iconStats = [UIImage imageWithIcon:@"fa-pie-chart" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    _statsImageView.image = iconStats;
    
    UIImage *iconReports = [UIImage imageWithIcon:@"fa-list-ol" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithWhite:1 alpha:0.3] fontSize:20];
    _reportsImageView.image = iconReports;
    
    UIImage *iconProd = [UIImage imageWithIcon:@"fa-rocket" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithWhite:1 alpha:0.3] fontSize:20];
    _productionImageView.image = iconProd;
    
    UIImage *iconDoc = [UIImage imageWithIcon:@"fa-book" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithWhite:1 alpha:0.3] fontSize:20];
    _documentationImageView.image = iconDoc;
}

- (void)setRunList:(NSMutableArray*)runList {
    
    _runCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[runList count]];
    int count = 0;
    for (int i=0; i < runList.count; ++i) {
        Run *run = runList[i];
        if ([[[run getStatus] lowercaseString] containsString:@"on hold"]) {
            count++;
        }
    }
    _roadBlocksLabel.text = cstrf(@"%d", count);
    [self getTargetsCount:runList];
}

- (void)setDemandList:(NSMutableArray*)demandList {
    _demandsCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[demandList count]];
}

- (void)setFeedbacksList:(NSMutableArray*)feedbacksList {
    _feedbacksCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[feedbacksList count]];
}

- (void)setProductsList:(NSMutableArray*)productsList {
    int count =0;
    int productionCount = 0;
    for (int i=0; i < productsList.count; ++i) {
        ProductModel *product = productsList[i];
        if ([product.status isEqualToString:@"OPEN"]||[product.status isEqualToString:@"Draft"]||[product.status isEqualToString:@"Open"]||[product.status isEqualToString:@"Pune Approved"]||[product.status isEqualToString:@"Mason Approved"]||[product.status isEqualToString:@"Mason Rejected"]||[product.status isEqualToString:@"Lausanne Rejected"]) {
            count++;
        }
        if ([product.productStatus isEqualToString:@"Production"]) {
            productionCount++;
        }
    }
    _processCountLabel.text = [NSString stringWithFormat:@"%d/%d",count,productionCount];
}

#pragma mark - Actions

- (IBAction) productionButtonTapped {
    [_delegate productionSelected];
}

- (IBAction)runsPressed:(id)sender {
    [_delegate runsSelected];
}

- (IBAction)demandsPressed:(id)sender {
    [_delegate demandsSelected];
}

- (IBAction)processControlPressed:(id)sender {
    [_delegate processControlSelected];
}

- (IBAction)feedbacksPressed:(id)sender {
    [_delegate feedbacksSelected];
}

- (IBAction) dailyLogButtonTapped {
    [_delegate dailyLogSelected];
}

- (IBAction) partsButtonTapped {
    [_delegate partsButtonTapped];
}

- (IBAction) roadBlocksButtonTapped {
    [_delegate roadBlocksSelected];
}

#pragma mark - Layout

- (void) setProcessesNumber:(int)c {
    
    _productionProcessesLabel.text = cstrf(@"%d", c);
    UIFont *f = ccFont(@"Roboto-Bold", 22);
    _processesLabelWidthConstraint.constant = [LayoutUtils widthForText:_productionProcessesLabel.text withFont:f];
}

- (void) setTargetsNumber:(int)c {
    
    _productionTargetsLabel.text = cstrf(@"%d", c);
    UIFont *f = ccFont(@"Roboto-Bold", 22);
    _targetsLabelWidthConstraint.constant = [LayoutUtils widthForText:_productionTargetsLabel.text withFont:f];
}

#pragma mark - Utils

- (void) getTargetsCount:(NSArray*)runList {
    
    __block int requests = 0;
    __block int goal = 0;
    __block int prCount = 0;
    NSDate *today = [NSDate date];
    for (Run *r in runList) {
        
        [[ProdAPI sharedInstance] getDailyLogForRun:[r getRunId] product:[r getProductNumber] completion:^(BOOL success, id response) {
            
            if (success) {
                NSArray *arr = [DayLogModel daysFromResponse:response forRun:nil];
                NSMutableArray *processes = [NSMutableArray array];
                for (DayLogModel *d in arr) {
                    if ([d.date isSameDayWithDate:today]) {
                        goal += d.goal;
                        if ([processes containsObject:d.processNo] == false) {
                            [processes addObject:d.processNo];
                        }
                    }
                }
                prCount += processes.count;
            }
            requests++;
            if (requests == runList.count) {
                [self setProcessesNumber:prCount];
                [self setTargetsNumber:goal];
            }
        }];
    }
}

@end
