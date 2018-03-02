//
//  OperatorsPlanningScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 27/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface OperatorsPlanningScreen : UIViewController

@property (nonatomic, unsafe_unretained) int numberOfOperators;
@property (nonatomic, strong) NSArray *operators;
@property (nonatomic, strong) NSArray *processes;
@property (nonatomic, strong) NSDictionary *targets;
@property (nonatomic, strong) Run *run;
@property (nonatomic, strong) NSDate *date;

@end
