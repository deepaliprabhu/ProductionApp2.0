//
//  SplashScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "SplashScreen.h"
#import "AppDelegate.h"
#import "SFHFKeychainUtils.h"
#import "Defines.h"
#import "UserManager.h"

@interface SplashScreen ()

@end

@implementation SplashScreen {
    __weak IBOutlet UILabel *_versionLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _versionLabel.text = cstrf(@"Version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self login];
    });
}

- (void) login {
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGEDIN_USER"];
    NSString *pass = [SFHFKeychainUtils getPasswordForKey:user andServiceName:@"PRODAPPLOGIN" error:nil];
    if (pass == nil) {
        [APPDEL goLogin];
    } else {
        [[UserManager sharedInstance] loginWithUser:user andPassword:pass withBlock:^(BOOL success) {
          
            if (success) {
                [APPDEL goHome];
            } else {
                [APPDEL goLogin];
            }
        }];
    }
}

@end
