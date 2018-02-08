//
//  WeeklyGraphBar.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 07/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface WeeklyGraphBar : UIView

__CREATEVIEWH(WeeklyGraphBar)

- (void) layoutWithText:(NSString*)text statusHeight:(float)s targetHeight:(float)t;

@end
