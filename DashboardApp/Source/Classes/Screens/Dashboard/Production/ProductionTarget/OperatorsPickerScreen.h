//
//  OperatorsPickerScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 30/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol OperatorsPickerScreenProtocol;

@interface OperatorsPickerScreen : UIViewController

@property (nonatomic, unsafe_unretained) id <OperatorsPickerScreenProtocol> delegate;
@property (nonatomic, unsafe_unretained) NSArray *operators;

@end

@protocol OperatorsPickerScreenProtocol <NSObject>

- (void) operatorChangedTo:(UserModel*)person;

@end
