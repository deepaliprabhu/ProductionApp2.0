//
//  NSDate+Utils.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (NSDate*) firstDateOfWeek;
- (BOOL) isThisWeek;
- (BOOL) isLastWeek;
- (BOOL) isNextWeek;
- (BOOL) isSameWeekWithDate:(NSDate *)date;
- (BOOL) isSameDayWithDate:(NSDate*)date;

@end
