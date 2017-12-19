//
//  DailyLogInputScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DailyLogInputScreen.h"

@interface DailyLogInputScreen ()

@end

@implementation DailyLogInputScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayout];
}

#pragma mark - Actions

- (void) cancelButtonTapped {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) saveButtonTapped {
    
}

#pragma mark - Layout

- (void) initLayout {
    
    self.title = @"";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
