//
//  DailyLogInputScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessModel.h"
#import "DayLogModel.h"

@protocol DailyLogInputProtocol;

@interface DailyLogInputScreen : UIViewController

@property (nonatomic, unsafe_unretained) ProcessModel *process;
@property (nonatomic, unsafe_unretained) DayLogModel *dayLog;
@property (nonatomic, unsafe_unretained) id <DailyLogInputProtocol> delegate;

@end

@protocol DailyLogInputProtocol <NSObject>

- (void) newLogAdded:(NSDictionary*)data;
- (void) updateLog:(NSDictionary*)data;

@end
