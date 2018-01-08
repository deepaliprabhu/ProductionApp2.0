//
//  UserModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 21/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *points;

+ (UserModel*) objectFromData:(NSDictionary*)data;
- (BOOL) isAdmin;

@end
