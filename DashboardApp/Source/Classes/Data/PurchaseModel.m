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
    m.vendor = data[@"Vendor"];
    m.createdDate = [_formatter dateFromString:data[@"created"]];
    m.expectedDate = [_formatter dateFromString:data[@"expectdate"]];
    m.status = data[@"status"];
    m.qty = data[@"qty"];
    m.price = data[@"price"];
    
    return m;
}

@end
