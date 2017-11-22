//
//  PartAuditModel.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 17/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartAuditModel : NSObject

@property (nonatomic, strong) NSArray *s2Actions;
@property (nonatomic, strong) NSArray *p2Actions;
@property (nonatomic, strong) NSArray *puneActions;
@property (nonatomic, strong) NSArray *masonActions;

+ (PartAuditModel*) objFrom:(NSArray*)a;

@end
