//
//  DailyLogHeaderView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyLogHeaderView : UIView

+ (CGFloat) height;
- (void) layoutWithDate:(NSDate*)date;

@end
