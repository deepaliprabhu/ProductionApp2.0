//
//  RunModel.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 14/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunModel.h"

@implementation RunModel

+ (RunModel*) objectFrom:(NSDictionary*)d {
    
    RunModel *r = [RunModel new];
    r.qty = d[@"Qty"];
    r.order = d[@"order"];
    r.productID = d[@"productid"];
    r.productName = d[@"productname"];
    r.runID = d[@"runid"];
    r.runSize = d[@"runsize"];
    return r;
}

@end
