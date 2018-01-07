//
//  DayLogModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayLogModel : NSObject

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, unsafe_unretained) int rework;
@property (nonatomic, unsafe_unretained) int reject;
@property (nonatomic, unsafe_unretained) int good;
@property (nonatomic, unsafe_unretained) int target;
@property (nonatomic, strong) NSString *processId;
@property (nonatomic, strong) NSString *dateAssigned;
@property (nonatomic, strong) NSString *dateCompleted;
@property (nonatomic, strong) NSString *person;
@property (nonatomic, strong) NSString *comments;

+ (DayLogModel*) objFromData:(NSDictionary*)data;
- (int) totalWork;

@end
