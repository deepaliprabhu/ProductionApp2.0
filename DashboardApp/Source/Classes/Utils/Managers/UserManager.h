//
//  UserManager.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserManager : NSObject

+ (UserManager*) sharedInstance;
- (void) loginWithUser:(NSString*)user andPassword:(NSString*)password withBlock:(void (^)(BOOL success))block;
- (UserModel*) loggedUser;
- (void) logout;

@end
