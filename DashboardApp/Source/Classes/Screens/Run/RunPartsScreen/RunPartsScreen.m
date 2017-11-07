//
//  RunPartsScreen.m
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunPartsScreen.h"
#import "ProdAPI.h"
#import "LoadingView.h"

@interface RunPartsScreen ()

@end

@implementation RunPartsScreen

- (void) viewDidLoad {

    [super viewDidLoad];
    [self getParts];
    [self getShorts];
}

#pragma mark - Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Utils

- (void) getParts {
    
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getPartsForRun:_run.runId withCompletion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

- (void) getShorts {
    
    [LoadingView showLoading:@"Loading..."];
    [[ProdAPI sharedInstance] getShortsForRun:_run.runId withCompletion:^(BOOL success, id response) {
        
        if (success) {
            [LoadingView removeLoading];
        } else {
            [LoadingView showShortMessage:@"Error, try again later!"];
        }
    }];
}

@end
