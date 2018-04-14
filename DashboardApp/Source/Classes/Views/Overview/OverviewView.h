//
//  OverviewView.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 16/08/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "MIBadgeButton.h"

@protocol OverviewViewDelegate;
@interface OverviewView : UIView {
    
    IBOutlet UILabel *_runCountLabel;
    IBOutlet UILabel *_demandsCountLabel;
    IBOutlet UILabel *_feedbacksCountLabel;
    IBOutlet UILabel *_processCountLabel;
    IBOutlet UIImageView *_statsImageView;
    IBOutlet UIImageView *_reportsImageView;
    IBOutlet UIImageView *_productionImageView;
    IBOutlet UIImageView *_documentationImageView;
}

__pd(OverviewViewDelegate);
__CREATEVIEWH(OverviewView);
- (void)initView;
- (void)setRunList:(NSMutableArray*)runList;
- (void)setDemandList:(NSMutableArray*)demandList;
- (void)setFeedbacksList:(NSMutableArray*)feedbacksList;
- (void)setProductsList:(NSMutableArray*)productsList;

@end

@protocol OverviewViewDelegate <NSObject>
- (void) runsSelected;
- (void) demandsSelected;
- (void) feedbacksSelected;
- (void) processControlSelected;
- (void) dailyLogSelected;
- (void) partsButtonTapped;
- (void) productionSelected;
- (void) roadBlocksSelected;
@end
