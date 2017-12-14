//
//  PartAuditModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionModel.h"

@interface PartAuditModel : NSObject

@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSArray *days;
@property (nonatomic, unsafe_unretained) int maxNegative;
@property (nonatomic, unsafe_unretained) int maxPositive;

+ (PartAuditModel*) objFrom:(NSArray*)a;

- (ActionModel*) lastMasonAction;
- (ActionModel*) lastPuneAction;
- (void) addAction:(ActionModel*)a;

- (void) computeData;

@end
