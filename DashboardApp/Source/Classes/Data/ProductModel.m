//
//  ProductModel.m
//  DashboardApp
//
//  Created by viggo on 05/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (ProductModel*) objectFrom:(NSDictionary*)data
{
    ProductModel *p = [ProductModel new];
    p.productID = data[@"Product Id"];
    p.productNumber = data[@"Product Number"];
    p.productStatus = data[@"Product Status"];
    p.status = data[@"Status"];
    p.name = data[@"Name"];
    p.photo = data[@"Images"];
    return p;
}

- (BOOL) isVisible
{
    BOOL status = ([_productStatus isEqualToString:@"Production"]||[_productStatus isEqualToString:@"In dev"]||[_productStatus isEqualToString:@"Active"]);
    return status;
}

- (NSURL*) photoURL {
    
    if (_photo == nil || _photo.length == 0) {
        return nil;
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"https://www.aginova.com/production_app_images/%@", _photo]];
    }
}

@end
