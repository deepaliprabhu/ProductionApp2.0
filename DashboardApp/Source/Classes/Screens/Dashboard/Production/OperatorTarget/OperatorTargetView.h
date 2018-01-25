//
//  OperatorTargetView.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@protocol OperatorTargetViewProtocol;

@interface OperatorTargetView : UIView

@property (nonatomic, unsafe_unretained) id <OperatorTargetViewProtocol> delegate;

__CREATEVIEWH(OperatorTargetView)

- (void) reloadData;

@end

@protocol OperatorTargetViewProtocol <NSObject>

- (void) goBackFromOperatorView;

@end
