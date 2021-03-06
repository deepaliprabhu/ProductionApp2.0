//
//  HomeViewController.h
//  DashboardApp
//
//  Created by Deepali Prabhu on 31/07/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunListView.h"
#import "OverviewView.h"
#import "DemandListView.h"
#import "TasklistView.h"
#import "GanttView.h"
#import "InProcessView.h"
#import "ToDoView.h"
#import "RoadBlocksView.h"
#import "FeedbackListView.h"
#import "FeedbackDetailView.h"
#import "FeedbackListViewController.h"

@interface HomeViewController : UIViewController<OverviewViewDelegate, RunListViewDelegate, DemandListViewDelegate> {
    
    IBOutlet UILabel *_inProcessCountLabel;
    IBOutlet UILabel *_todoCountLabel;
    IBOutlet UILabel *_roadblocksCountLabel;
    IBOutlet UIButton *_tasklistButton;
    IBOutlet UIButton *_activityLogButton;
    IBOutlet UIImageView *_doneImageView;
    IBOutlet UIImageView *_todoImageView;
    IBOutlet UIImageView *_roadblocksImageView;
    IBOutlet UIImageView *_activityLogImageView;
    IBOutlet UIImageView *_tasklistImageView;
    IBOutlet UIView *_overviewView;
    IBOutlet UIView *_leftPaneView;
    IBOutlet UIView *_bottomPaneView;
    IBOutlet UIView *_inProcessView;
    IBOutlet UIView *_todoView;
    IBOutlet UIView *_roadBlocksView;
    UIView *movableView;
    
    RunListView *runListView;
    FeedbackListView *feedbackListView;
    OverviewView *overviewView;
    DemandListView *demandListView;
    TasklistView *tasklistView;
    InProcessView *inProcessView;
    ToDoView *todoView;
    RoadBlocksView *roadBlocksView;
    GanttView *ganttView;
    GanttView *pcbGanttView;
    
    NSMutableArray *runsListArray;
    NSMutableArray *demandListArray;
    
    float oldX, oldY;
    BOOL dragging;
    int selectedRunType;
}

@end
