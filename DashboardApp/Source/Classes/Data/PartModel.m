//
//  PartModel.m
//  DashboardApp
//
//  Created by viggo on 07/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartModel.h"

@implementation PartModel

+ (PartModel*) partFrom:(NSDictionary*)data
{
    PartModel *p = [PartModel new];
    p.lausanne = data[@"Lausanne"];
    p.mason = data[@"Mason"];
    p.recoMason = data[@"RECO_MASON"];
    p.pune = data[@"Pune"];
    p.recoPune = data[@"RECO_PUNE"];
    p.p2 = data[@"P2"];
    p.recoP2 = data[@"RECO_P2"];
    p.s2 = data[@"S2"];
    p.recoS2 = data[@"RECO_S2"];
    p.color = data[@"color"];
    p.count = data[@"count"];
    p.part = data[@"part"];
    p.po = data[@"po"];
    p.transferID = data[@"transfer id"];
    
    return p;
}

@end
