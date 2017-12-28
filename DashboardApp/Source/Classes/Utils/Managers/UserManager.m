//
//  UserManager.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "UserManager.h"
#import "ProdAPI.h"
#import "LoadingView.h"
#import "SFHFKeychainUtils.h"

static UserManager *_sharedInstance = nil;

@implementation UserManager {
    
    UserModel *_user;
}

+ (UserManager*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });
    
    return _sharedInstance;
}

- (UserModel*) loggedUser {
    return _user;
}

- (void) logout {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGGEDIN_USER"];
    
    _user = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LOGGEDIN_USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SFHFKeychainUtils deleteItemForUsername:username andServiceName:@"PRODAPPLOGIN" error:nil];
}

- (void) setLoggedUser:(UserModel*)user forPassword:(NSString*)pass {
 
    _user = user;
    
    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"LOGGEDIN_USER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SFHFKeychainUtils storeUsername:user.username andPassword:pass forServiceName:@"PRODAPPLOGIN" updateExisting:true error:nil];
}

- (void) loginWithUser:(NSString*)user andPassword:(NSString*)password withBlock:(void (^)(BOOL success))block {
    
    [[ProdAPI sharedInstance] loginWithUser:user password:password withCompletion:^(BOOL success, id response) {
       
        if (success) {
            
            id r = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            if ([r isKindOfClass:[NSArray class]]) {
                UserModel *user = [UserModel objectFromData:[r firstObject]];
                [self setLoggedUser:user forPassword:password];
                block(true);
            } else {
                [LoadingView showShortMessage:@"User/pass incorrect or account doesn't exist"];
                block(false);
            }
        } else {
            [LoadingView showShortMessage:@"Error, please try again later!"];
            block(false);
        }
    }];
}

@end
