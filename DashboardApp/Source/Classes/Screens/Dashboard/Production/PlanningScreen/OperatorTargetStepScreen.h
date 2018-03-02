//
//  OperatorTargetStepScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/02/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperatorTargetStepScreenProtocol;

@interface OperatorTargetStepScreen : UIViewController

@property (nonatomic, strong) NSArray *operators;
@property (nonatomic, strong) NSArray *existingTargets;
@property (nonatomic, unsafe_unretained) id <OperatorTargetStepScreenProtocol> delegate;

@end


@protocol OperatorTargetStepScreenProtocol <NSObject>

- (void) operatorData:(NSArray*)data;

@end
