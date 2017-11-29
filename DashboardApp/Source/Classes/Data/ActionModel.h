//
//  ActionModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionModel : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *prevQTY;
@property (nonatomic, strong) NSString *process;

+ (ActionModel*) objFrom:(NSDictionary*)d;

@end
