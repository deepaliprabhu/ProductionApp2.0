//
//  RunModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 14/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunModel : NSObject

@property (nonatomic, copy) NSString *qty;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *runSize;
@property (nonatomic, copy) NSString *runID;

+ (RunModel*) objectFrom:(NSDictionary*)d;

@end
