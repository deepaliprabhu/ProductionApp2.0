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
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:0.5].CGColor;
    self.layer.cornerRadius = 8.0;
    
   // _partsButton.layer.cornerRadius = 6.0f;
    _demandListButton.layer.cornerRadius = 6.0f;
    _openRunsButton.layer.cornerRadius = 6.0f;
    _rmaButton.layer.cornerRadius = 6.0f;
    //_supportButton.layer.cornerRadius = 6.0f;
   /* _monitoringButton.layer.cornerRadius = 6.0f;
    _inventoryButton.layer.cornerRadius = 6.0f;
    _installationButton.layer.cornerRadius = 6.0f;
    _orderProcessingButton.layer.cornerRadius = 6.0f;*/
    
    UIImage *iconStats = [UIImage imageWithIcon:@"fa-pie-chart" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] fontSize:20];
    _statsImageView.image = iconStats;
    
    UIImage *iconReports = [UIImage imageWithIcon:@"fa-list-ol" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
    _reportsImageView.image = iconReports;
    
    UIImage *iconProd = [UIImage imageWithIcon:@"fa-rocket" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
    _productionImageView.image = iconProd;
    
    UIImage *iconDoc = [UIImage imageWithIcon:@"fa-book" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] fontSize:20];
    _documentationImageView.image = iconDoc;
    
    runsGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    runsGradientView.topColor = [UIColor colorWithRed:37.0f/255.0f green:85.0f/255.0f blue:104.0f/255.0f alpha:1];
    runsGradientView.bottomColor = [UIColor colorWithRed:44.0f/255.0f green:136.0f/255.0f blue:126.0f/255.0f alpha:1];
    [_ongoingRunsBgView addSubview:runsGradientView];
    
    demandsGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_demandListBgView.frame.size.width, _demandListBgView.frame.size.height)];
    demandsGradientView.topColor = [UIColor colorWithRed:58.0f/255.0f green:101.0f/255.0f blue:115.0f/255.0f alpha:1];
    demandsGradientView.bottomColor = [UIColor colorWithRed:65.0f/255.0f green:156.0f/255.0f blue:139.0f/255.0f alpha:1];
    [_demandListBgView addSubview:demandsGradientView];
    
    rmaGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_rmaBgView.frame.size.width, _rmaBgView.frame.size.height)];
    rmaGradientView.topColor = [UIColor colorWithRed:62.0f/255.0f green:110.0f/255.0f blue:109.0f/255.0f alpha:1];
    rmaGradientView.bottomColor = [UIColor colorWithRed:72.0f/255.0f green:150.0f/255.0f blue:125.0f/255.0f alpha:1];
    [_rmaBgView addSubview:rmaGradientView];
    
    feedbackGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    feedbackGradientView.topColor = [UIColor colorWithRed:73.0f/255.0f green:121.0f/255.0f blue:133.0f/255.0f alpha:1];
    feedbackGradientView.bottomColor = [UIColor colorWithRed:81.0f/255.0f green:168.0f/255.0f blue:156.0f/255.0f alpha:1];
    [_feedbackBgView addSubview:feedbackGradientView];
    
    stockGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    stockGradientView.topColor = [UIColor colorWithRed:82.0f/255.0f green:167.0f/255.0f blue:157.0f/255.0f alpha:1];
    stockGradientView.bottomColor = [UIColor colorWithRed:78.0f/255.0f green:136.0f/255.0f blue:143.0f/255.0f alpha:1];
    [_stockBgView addSubview:stockGradientView];
    
    logGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    logGradientView.topColor = [UIColor colorWithRed:70.0f/255.0f green:150.0f/255.0f blue:124.0f/255.0f alpha:1];
    logGradientView.bottomColor = [UIColor colorWithRed:64.0f/255.0f green:116.0f/255.0f blue:111.0f/255.0f alpha:1];
    [_dailyLogBgView addSubview:logGradientView];
    
    shipmentGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    shipmentGradientView.topColor = [UIColor colorWithRed:86.0f/255.0f green:170.0f/255.0f blue:154.0f/255.0f alpha:1];
    shipmentGradientView.bottomColor = [UIColor colorWithRed:77.0f/255.0f green:120.0f/255.0f blue:133.0f/255.0f alpha:1];
    [_shipmentBgView addSubview:shipmentGradientView];
    
    historyGradientView = [[SSGradientView alloc] initWithFrame:CGRectMake(0, 0,_ongoingRunsBgView.frame.size.width, _ongoingRunsBgView.frame.size.height)];
    historyGradientView.topColor = [UIColor colorWithRed:65.0f/255.0f green:156.0f/255.0f blue:140.0f/255.0f alpha:1];
    historyGradientView.bottomColor = [UIColor colorWithRed:59.0f/255.0f green:103.0f/255.0f blue:115.0f/255.0f alpha:1];
    [_historyBgView addSubview:historyGradientView];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setRunList:(NSMutableArray*)runList {
    //[_openRunsButton setBadgeEdgeInsets:UIEdgeInsetsMake(10, 3, 3, 12)];
    //[_openRunsButton setBadgeString:[NSString stringWithFormat:@"%d",[runList count]]];
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
