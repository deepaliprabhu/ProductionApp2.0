//
//  BuyerSelectionScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/03/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyerSelectionScreenProtocol;

@interface BuyerSelectionScreen : UIViewController

@property (nonatomic, unsafe_unretained) BOOL forLocation;
@property (nonatomic, unsafe_unretained) id <BuyerSelectionScreenProtocol> delegate;

@end


@protocol BuyerSelectionScreenProtocol <NSObject>

- (void) newBuyerForSelectedPart:(NSString*)buyer;

@end
