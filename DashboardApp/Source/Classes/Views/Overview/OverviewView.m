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

@implementation OverviewView
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
        if ([product.status isEqualToString:@"OPEN"]||[product.status isEqualToString:@"Draft"]||[product.status isEqualToString:@"Open"]||[product.status isEqualToString:@"Pune Approved"]||[product.status isEqualToString:@"Mason Approved"]) {
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

@end
