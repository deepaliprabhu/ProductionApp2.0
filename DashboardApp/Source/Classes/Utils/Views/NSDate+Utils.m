//
//  NSDate+Utils.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 15/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSDate*) firstDateOfWeek {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startOfWeek;
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&startOfWeek interval:NULL forDate:self];
    return startOfWeek;
}

- (BOOL) isSameDayWithDate:(NSDate*)date {
    return [[NSCalendar currentCalendar] isDate:self inSameDayAsDate:date];
}

- (BOOL) isSameWeekWithDate:(NSDate *)date {
    
    if (ABS(self.timeIntervalSince1970 - date.timeIntervalSince1970) > (7 * 24 * 60 * 60)) {
        return NO;
    }
    return ([[self firstDateOfWeek] timeIntervalSince1970] == [[date firstDateOfWeek] timeIntervalSince1970]);
}

- (BOOL) isThisWeek {
    return [self isSameWeekWithDate:[NSDate new]];
}

- (BOOL) isLastWeek {
    return [self isSameWeekWithDate:[[NSDate new] dateByAddingTimeInterval:-7*24*3600]];
}

- (BOOL) isNextWeek {
    return [self isSameWeekWithDate:[[NSDate new] dateByAddingTimeInterval:7*24*3600]];
}

@end
