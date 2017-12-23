//
//  UserModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel*) objectFromData:(NSDictionary*)data {
    
    UserModel *u = [UserModel new];
    u.userId = data[@"userid"];
    u.username = data[@"username"];
    u.rating = data[@"username"];
    u.name = data[@"name"];
    u.role = data[@"role"];
    u.status = data[@"status"];
    u.points = data[@"points"];
    
    return u;
}

@end
