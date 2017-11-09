//
//  HomeViewController.m
//  DashboardApp
//
//  Created by Deepali Prabhu on 31/07/17.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "HomeViewController.h"
#import "ServerManager.h"
#import "DataManager.h"
#import "Constants.h"
#import "RunViewController.h"
#import "UIImage+FontAwesome.h"
#import "GanttView.h"
#import "UIView+RNActivityView.h"
#import "ProductListViewController.h"
#import "UIView+Screenshot.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];
    [center addObserver:self selector:@selector(initDemands) name:kNotificationDemandsReceived object:nil];
    self.navigationController.navigationBar.hidden = true;

    UIImage *iconDone = [UIImage imageWithIcon:@"fa-calendar-check-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    _doneImageView.image = iconDone;
    
    UIImage *iconTodo = [UIImage imageWithIcon:@"fa-calendar" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    _todoImageView.image = iconTodo;
    
    UIImage *iconBlock = [UIImage imageWithIcon:@"fa-lightbulb-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    _roadblocksImageView.image = iconBlock;
    
    UIImage *iconActivity = [UIImage imageWithIcon:@"fa-eye" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    _activityLogImageView.image = iconActivity;
    
    UIImage *iconTasklist = [UIImage imageWithIcon:@"fa-tasks" backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:25];
    _tasklistImageView.image = iconTasklist;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    topBarView = [TopBarView createView];
    topBarView.frame = CGRectMake(0, 0, _topPaneView.frame.size.width, _topPaneView.frame.size.height);
    [topBarView initView];
    [_topPaneView addSubview:topBarView];
    
    runListView = [RunListView createView];
    runListView.frame = CGRectMake(0, 0, _overviewView.frame.size.width, _overviewView.frame.size.height);
    [runListView initView];
    runListView.delegate = self;
    [_overviewView addSubview:runListView];
    runListView.hidden = true;
    
    demandListView = [DemandListView createView];
    demandListView.frame = CGRectMake(0, 0, _overviewView.frame.size.width, _overviewView.frame.size.height);
    [demandListView initView];
    demandListView.delegate = self;
    [_overviewView addSubview:demandListView];
    demandListView.hidden = true;
    
    overviewView = [OverviewView createView];
    overviewView.frame = CGRectMake(0, 0, _overviewView.frame.size.width, _overviewView.frame.size.height);
    [overviewView initView];
    overviewView.delegate = self;
    [_overviewView addSubview:overviewView];
    
    tasklistView = [TasklistView createView];
    tasklistView.frame = CGRectMake(0, 50, _leftPaneView.frame.size.width, _leftPaneView.frame.size.height-50);
    [tasklistView initView];
    //tasklistView.delegate = self;
    [_leftPaneView addSubview:tasklistView];
    
    inProcessView = [InProcessView createView];
    inProcessView.frame = CGRectMake(0, 50, _inProcessView.frame.size.width, _inProcessView.frame.size.height-50);
    inProcessView.delegate = self;
    [_inProcessView addSubview:inProcessView];
    
    todoView = [ToDoView createView];
    todoView.frame = CGRectMake(0, 50, _todoView.frame.size.width, _todoView.frame.size.height-50);
    todoView.delegate = self;
    //[_todoView addSubview:todoView];
    
    roadBlocksView = [RoadBlocksView createView];
    roadBlocksView.frame = CGRectMake(0, 50, _inProcessView.frame.size.width, _inProcessView.frame.size.height-50);
    roadBlocksView.delegate = self;
    [_roadBlocksView addSubview:roadBlocksView];
    
    ganttView = [GanttView createView];
    ganttView.frame = CGRectMake(0, 0, _bottomPaneView.frame.size.width, _bottomPaneView.frame.size.height);
    [ganttView initView];
    ganttView.hidden = true;
    //tasklistView.delegate = self;
    [_bottomPaneView addSubview:ganttView];
    
    pcbGanttView = [GanttView createView];
    pcbGanttView.frame = CGRectMake(0, 0, _bottomPaneView.frame.size.width, _bottomPaneView.frame.size.height);
    [pcbGanttView initView];
    pcbGanttView.hidden = true;
    //tasklistView.delegate = self;
    [_bottomPaneView addSubview:pcbGanttView];
    
    [_activityLogButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:248.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    
    [self.view bringSubviewToFront:_titleButton];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    [__ServerManager getRunsList];
    [__ServerManager getDemands];
    selectedRunType = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// OverviewViewDelegate methods
- (void) runsSelected {
    overviewView.hidden = true;
    runListView.hidden = false;
    ganttView.hidden = false;
}

- (void) demandsSelected {
    overviewView.hidden = true;
    demandListView.hidden = false;
}

- (void) processControlSelected {
    ProductListViewController *productListVC = [ProductListViewController new];
    productListVC.image = [self.view screenshot];
    [self.navigationController pushViewController:productListVC animated:true];
}

- (void) closeSelected {
    overviewView.hidden = false;
    demandListView.hidden = true;
    runListView.hidden = true;
    ganttView.hidden = true;
}

- (void) initRuns {
    runsListArray = [__DataManager getRuns];
    NSLog(@"runlistArray = %@",runsListArray);
    [runListView setRunList:runsListArray];
    [overviewView setRunList:runsListArray];
    [inProcessView initView];
    [todoView initView];
    [roadBlocksView initView];
    [self.navigationController.view hideActivityView];
}

- (void) initDemands {
    demandListArray = [__DataManager getDemandList];
    NSLog(@"demandListArray = %@",demandListArray);
    [demandListView setDemandList:demandListArray];
    [overviewView setDemandList:demandListArray];
}

- (void) runSelectedAtIndex:(int)runId {
    RunViewController *runVC = [RunViewController new];
    [runVC setRun:[__DataManager getRunWithId:runId]];
    [self.navigationController pushViewController:runVC animated:false];
}

- (void) runSelected:(Run*)run {
    RunViewController *runVC = [RunViewController new];
    [runVC setRun:run];
    [self.navigationController pushViewController:runVC animated:false];
}

- (void)selectedRunType:(int)runType {
    selectedRunType = runType;
    if (runType == 0) {
        ganttView.hidden = true;
        pcbGanttView.hidden = false;
        [pcbGanttView setStationsArrayForRunType:runType];
    }
    else {
        pcbGanttView.hidden = true;
        ganttView.hidden = false;
        [ganttView setStationsArrayForRunType:runType];
    }
}

- (IBAction)tasklistPressed:(id)sender {
    [_tasklistButton setBackgroundColor:[UIColor whiteColor]];
    [_activityLogButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:248.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    tasklistView.hidden = false;
}

- (IBAction)activityLogPressed:(id)sender {
    [_tasklistButton setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:248.0f/255.0f blue:251.0f/255.f alpha:1.0f]];
    [_activityLogButton setBackgroundColor:[UIColor whiteColor]];
    tasklistView.hidden = true;
}

- (IBAction)titleButtonPressed:(id)sender {
    overviewView.hidden = false;
    runListView.hidden = true;
    demandListView.hidden = true;
    ganttView.hidden = true;
}

- (void)setInProcessLabel:(int)count {
    _inProcessCountLabel.text = [NSString stringWithFormat:@"In Process (%d)",count];
}

- (void)setToDoLabel:(int)count {
    _todoCountLabel.text = [NSString stringWithFormat:@"To Do (%d)",count];
}

- (void)setRoadBlocksLabel:(int)count {
    _roadblocksCountLabel.text = [NSString stringWithFormat:@"Road Blocks (%d)",count];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLoc = [touch locationInView:self.view];
    CGPoint touchLocation = [touch locationInView:[runListView getDragView]];
    CGPoint touchLocation1 = [touch locationInView:[ganttView getDragView]];
    NSLog(@"touchlocation x=%f, y=%f",touchLocation.x, touchLocation.y);
    NSLog(@"touchlocation1 x=%f, y=%f",touchLocation1.x, touchLocation1.y);

    if ([touch view] == [runListView getDragView])
    {
        //Action
        movableView = [[UIView alloc] init];
        NSLog(@"touch inside runlist");
        Run *run = [runListView getRunAtLocation:touchLocation];
        if (!run) {
            return;
        }
        dragging = YES;
        movableView.frame = CGRectMake(_overviewView.frame.origin.x+(touchLocation.x-movableView.frame.size.width/2), _overviewView.frame.origin.y+[runListView getDragView].frame.origin.y+ touchLocation.y-movableView.frame.size.height/2, 46, 22);
        movableView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:movableView];
        
        UILabel *runIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 46, 22)];
        runIdLabel.font = [UIFont systemFontOfSize:10.0f];
        runIdLabel.textAlignment = NSTextAlignmentCenter;
        movableView.backgroundColor = [run getRunColor];
        runIdLabel.textColor = [UIColor whiteColor];
        runIdLabel.text = [NSString stringWithFormat:@"%d",[run getRunId]];
        runIdLabel.tag = 100;
        [movableView addSubview:runIdLabel];
    }
    
   if ([touch view] == [ganttView getDragView]) {
        //Action
       //movableView = [[UIView alloc] init];
        NSLog(@"touch inside ganttview");
       UIView *ganttMovView = [ganttView getViewAtLocation:touchLocation1];
       movableView = ganttMovView;
       if (!movableView) {
           return;
       }
       dragging = YES;
       [ganttView clearViewAtLocation:touchLocation1];
       movableView.frame = CGRectMake(touchLoc.x-movableView.frame.size.width/2, touchLoc.y-movableView.frame.size.height/2, 46, 22);;
      // movableView.frame = CGRectMake([ganttView getDragView].frame.origin.x+(touchLocation1.x-movableView.frame.size.width/2), ganttView.frame.origin.y+ touchLocation1.y-movableView.frame.size.height/2, 46, 22);
       [self.view addSubview:movableView];
       //[ganttMovView removeFromSuperview];
    }
    
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)touch.view;
        if (CGRectContainsPoint(label.frame, touchLocation)) {
            oldX = touchLocation.x;
            oldY = touchLocation.y;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!dragging) {
        return;
    }
    dragging = NO;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    CGPoint ganttTouchLoc = [touch locationInView:ganttView];
    CGPoint pcbGanttTouchLoc = [touch locationInView:ganttView];


    if ((touchLocation.x < 200)||(touchLocation.y < _bottomPaneView.frame.origin.y+60)) {
        NSLog(@"touch stopped");
        [movableView removeFromSuperview];
    }
    else {
        UILabel *runIdLabel = (UILabel*)[movableView viewWithTag:100];
        if([runIdLabel.text containsString:@","]) {
            NSArray *runsArray = [runIdLabel.text componentsSeparatedByString:@","];
            for (int i=0; i < runsArray.count; ++i) {
                if (selectedRunType == 0) {
                    [pcbGanttView setCellWithRun:[__DataManager getRunWithId:[runsArray[i] intValue]] andLocation:ganttTouchLoc];
                }
                else {
                    [ganttView setCellWithRun:[__DataManager getRunWithId:[runsArray[i] intValue]] andLocation:ganttTouchLoc];
                }
            }
        }
        else {
            if (selectedRunType == 0) {
                [pcbGanttView setCellWithRun:[__DataManager getRunWithId:[runIdLabel.text intValue]] andLocation:ganttTouchLoc];
            }
            else {
                [ganttView setCellWithRun:[__DataManager getRunWithId:[runIdLabel.text intValue]] andLocation:ganttTouchLoc];
            }
        }
        //[ganttView setCellWithView:movableView atLocation:ganttTouchLoc];
        [movableView removeFromSuperview];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!dragging) {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];

    if (([touch view] == runListView)||([touch view] == [runListView getDragView])||([touch view] == [ganttView getDragView]))
    {
        //Action
        NSLog(@"touch moved");
        movableView.frame = CGRectMake(touchLocation.x-movableView.frame.size.width/2, touchLocation.y-movableView.frame.size.height/2, 46, 22);

    }
    
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)touch.view;
        
        if (dragging) {
            CGRect frame = label.frame;
            frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
            frame.origin.y =  label.frame.origin.y + touchLocation.y - oldY;
            label.frame = frame;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
