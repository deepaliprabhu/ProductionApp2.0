//
//  RunListScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 09/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "RunListScreen.h"
#import "RunListView.h"
#import "RunCommentsScreen.h"
#import "RunDetailsScreen.h"
#import "DataManager.h"

@interface RunListScreen () <RunListViewDelegate>

@end

@implementation RunListScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Layout

- (void) initLayout {
    
    RunListView *list = [RunListView createView];
    list.frame = CGRectMake(9, 90, 635, 667);
    list.delegate = self;
    [list setRunList:[NSMutableArray arrayWithArray:_runsList]];
    [self.view addSubview:list];
}

#pragma mark - RunListDelegate

- (void) showCommentsForRun:(Run*)run {
 
    RunCommentsScreen *screen = [[RunCommentsScreen alloc] initWithNibName:@"RunCommentsScreen" bundle:nil];
    screen.run = run;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:screen];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:true completion:nil];
}

- (void) runSelectedAtIndex:(int)runId {
    
    RunDetailsScreen *screen = [RunDetailsScreen new];
    screen.run = [[DataManager sharedInstance] getRunWithId:runId];
    [self.navigationController pushViewController:screen animated:true];
}

@end
