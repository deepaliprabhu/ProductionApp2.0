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
#import "Run.h"

@protocol DailyLogInputProtocol;

@interface DailyLogInputScreen : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, unsafe_unretained) ProcessModel *process;
@property (nonatomic, unsafe_unretained) DayLogModel *dayLog;
@property (nonatomic, unsafe_unretained) Run *run;
@property (nonatomic, unsafe_unretained) id <DailyLogInputProtocol> delegate;
@property (nonatomic, strong) NSString *operatorName;

@end

@protocol DailyLogInputProtocol <NSObject>

- (void) newLogAdded:(NSDictionary*)data;
- (void) updateLog:(NSDictionary*)data;

@end
