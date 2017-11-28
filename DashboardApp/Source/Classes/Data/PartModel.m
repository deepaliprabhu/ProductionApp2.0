//
//  PartModel.m
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartModel.h"
#import "PurchaseModel.h"
#import "ProdAPI.h"

static NSDateFormatter *_formatter = nil;

@implementation PartModel

+ (PartModel*) partFrom:(NSDictionary*)data isShort:(BOOL)s
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
    p.partDescription = data[@"description"];
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
    
    if (s == false)
        p.pricePerUnit = data[@"price_per_unit"];
    p.qty = data[@"qty_per_pcb"];
    p.shortValue = data[@"short"];
    p.transit = data[@"transit"];
    p.transitDate = [_formatter dateFromString:data[@"transit_date"]];
    p.transferID = data[@"transfer_id"];
    p.vendor = data[@"vendor"];
    p.alternateParts = [self alternatePartsFrom:data[@"alternate_part"]];
    
    return p;
}

+ (NSArray*) alternatePartsFrom:(NSString*)data
{
    if (data.length == 0)
        return nil;
    else
    {
        NSArray *comps = [data componentsSeparatedByString:@" , "];
        NSMutableArray *parts = [NSMutableArray array];
        for (NSString *str in comps) {
            PartModel *p = [PartModel new];
            p.part = str;
            [parts addObject:p];
        }
        
        return parts;
    }
}

- (int) totalPune {

    int p = [_pune intValue];
//    if (_recoPune.length > 0) {
//        p = [_recoPune intValue];
//    }
    int p2 = [_p2 intValue];
//    if (_recoP2.length > 0) {
//        p2 = [_recoP2 intValue];
//    }
    int s2 = [_s2 intValue];
//    if (_recoS2.length > 0) {
//        s2 = [_recoS2 intValue];
//    }
    
    return p+s2+p2;
}

- (int) totalStock {
    
    int m = [_mason intValue];
//    if (_recoMason.length > 0) {
//        m = [_recoMason intValue];
//    }
    
    int total = m + [self totalPune] + [_transit intValue] + [_lausanne intValue];
    return total;
}

- (int) openPOQty
{
    int t = 0;
    for (PurchaseModel *p in _purchases) {
        
        if ([p.status isEqualToString:@"Closed"] == false)
            t += [p.qty intValue];
    }
    
    return t;
}

- (void) getHistory
{
    [[ProdAPI sharedInstance] getHistoryFor:_part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            
            if ([response isKindOfClass:[NSArray class]]) {
                _priceHistory = [NSArray arrayWithArray:response];
            } else {
                _priceHistory = @[];
            }
        } else {
            _priceHistory = @[];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEPARTHISTORY" object:nil];
    }];
}

- (void) getPurchases {
    
    [[ProdAPI sharedInstance] getPurchasesForPart:_part withCompletion:^(BOOL success, id response) {
        
        if (success) {
            
            NSMutableArray *arr = [NSMutableArray array];
            if ([response isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in response) {
                    [arr addObject:[PurchaseModel objFrom:d]];
                }
                [arr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:false]]];
            }
            _purchases = [NSArray arrayWithArray:arr];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEPARTHISTORY" object:nil];
    }];
}

@end
