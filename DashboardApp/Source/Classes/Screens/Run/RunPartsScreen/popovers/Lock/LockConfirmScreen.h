//
//  LockConfirmScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface LockConfirmScreen : UIViewController

@property (nonatomic, strong) NSArray *runParts;
@property (nonatomic, unsafe_unretained) Run *run;

@end
