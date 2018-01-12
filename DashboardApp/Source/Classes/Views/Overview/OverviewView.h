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
#import "SSGradientView.h"

@protocol OverviewViewDelegate;
@interface OverviewView : UIView {
    IBOutlet UILabel *_runCountLabel;
    IBOutlet UILabel *_demandsCountLabel;
    IBOutlet UILabel *_feedbacksCountLabel;
    IBOutlet UILabel *_processCountLabel;
    //IBOutlet UIButton *_partsButton;
    IBOutlet UIButton *_demandListButton;
    IBOutlet UIButton *_openRunsButton;
    IBOutlet UIButton *_rmaButton;
    IBOutlet UIImageView *_statsImageView;
    IBOutlet UIImageView *_reportsImageView;
    IBOutlet UIImageView *_productionImageView;
    IBOutlet UIImageView *_documentationImageView;
    IBOutlet UIView *_ongoingRunsBgView;
    IBOutlet UIView *_demandListBgView;
    IBOutlet UIView *_rmaBgView;
    IBOutlet UIView *_feedbackBgView;
    IBOutlet UIView *_stockBgView;
    IBOutlet UIView *_dailyLogBgView;
    IBOutlet UIView *_shipmentBgView;
    IBOutlet UIView *_historyBgView;
    
    SSGradientView *runsGradientView;
    SSGradientView *demandsGradientView;
    SSGradientView *rmaGradientView;
    SSGradientView *feedbackGradientView;
    SSGradientView *stockGradientView;
    SSGradientView *logGradientView;
    SSGradientView *shipmentGradientView;
    SSGradientView *historyGradientView;
   /* IBOutlet UIButton *_supportButton;
    IBOutlet UIButton *_inventoryButton;
    IBOutlet UIButton *_monitoringButton;
    IBOutlet UIButton *_installationButton;
    IBOutlet UIButton *_orderProcessingButton;*/
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
@end
