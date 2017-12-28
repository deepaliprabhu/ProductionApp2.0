//
//  UserDetailsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "UserDetailsScreen.h"
#import "UserManager.h"
#import "UserModel.h"
#import "AppDelegate.h"

@interface UserDetailsScreen ()

@end

@implementation UserDetailsScreen {
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_roleLabel;
    __weak IBOutlet UILabel *_emailLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(322, 167);
    
    UserModel *u = [[UserManager sharedInstance] loggedUser];
    _nameLabel.text = u.name;
    _emailLabel.text = u.username;
    _roleLabel.text = u.role;
}

- (IBAction) logoutButtonTapped {
    
    [[UserManager sharedInstance] logout];
    [self dismissViewControllerAnimated:true completion:^{
        AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [del goLogin];
    }];
}

@end
