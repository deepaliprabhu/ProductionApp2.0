//
//  PurchaseModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 10/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PurchaseModel.h"

static NSDateFormatter *_formatter = nil;

@implementation PurchaseModel

+ (PurchaseModel*) objFrom:(NSDictionary*)data {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    });
    
    PurchaseModel *m = [PurchaseModel new];
    m.poID = data[@"poid"];
    
    if ([data[@"Vendor"] isKindOfClass:[NSString class]])
        m.vendor = data[@"Vendor"];
    else
        m.vendor = @"";
    m.createdDate = [_formatter dateFromString:data[@"created"]];
    m.expectedDate = [_formatter dateFromString:data[@"expectdate"]];
    m.status = data[@"status"];
    m.qty = data[@"qty"];
    m.price = data[@"price"];
    if ([data[@"arriveddate"] isKindOfClass:[NSString class]])
        m.arrivedDate = [_formatter dateFromString:data[@"arriveddate"]];
    
    if (m.arrivedDate != nil)
        m.expectedDate = m.arrivedDate;
    
    if ([[m.status lowercaseString] rangeOfString:@"arrived"].location != NSNotFound)
    {
        if ([m.status isEqualToString:@"Partially arrived"])
        {
            if (m.arrivedDate != nil)
                m.status = @"Closed";
        }
        else
            m.status = @"Closed";
    }
    
    return m;
}

@end
