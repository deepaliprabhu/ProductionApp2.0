//
//  PartModel.m
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartModel.h"

static NSDateFormatter *_formatter = nil;

@implementation PartModel

+ (PartModel*) partFrom:(NSDictionary*)data
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    });
    
    PartModel *p = [PartModel new];
    p.lausanne = data[@"Lausanne"];
    p.mason = data[@"Mason"];
    p.p2 = data[@"P2"];
    p.pune = data[@"Pune"];
    p.recoMason = data[@"RECO_MASON"];
    p.recoMasonDate = [_formatter dateFromString:data[@"RECO_MASON_DATE"]];
    p.recoP2 = data[@"RECO_P2"];
    p.recoP2Date = [_formatter dateFromString:data[@"RECO_P2_DATE"]];
    p.recoPune = data[@"RECO_PUNE"];
    p.recoPuneDate = [_formatter dateFromString:data[@"RECO_PUNE_DATE"]];
    p.recoS2 = data[@"RECO_S2"];
    p.recoS2Date = [_formatter dateFromString:data[@"RECO_S2_DATE"]];
    p.s2 = data[@"S2"];
    p.color = data[@"color"];
    p.part = data[@"part"];
    
    NSString *po = data[@"po"];
    if (po.length > 0) {
        po = [po stringByReplacingOccurrencesOfString:@"<span >(" withString:@""];
        po = [po stringByReplacingOccurrencesOfString:@")</span>" withString:@""];
        p.po = po;
    }
    p.pricePerUnit = data[@"price_per_unit"];
    p.qty = data[@"qty_per_pcb"];
    p.shortValue = data[@"short"];
    p.transit = data[@"transit"];
    p.transitDate = [_formatter dateFromString:data[@"transit_date"]];
    p.vendor = data[@"vendor"];
    
    return p;
}

- (int) totalStock {
    int total = [_mason intValue] + [_pune intValue] + [_transit intValue] + [_lausanne intValue];
    return total;
}

@end
