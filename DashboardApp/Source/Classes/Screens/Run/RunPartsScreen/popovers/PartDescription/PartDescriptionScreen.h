//
//  PartDescriptionScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"

@protocol PartDescriptionScreenProtocol;

@interface PartDescriptionScreen : UIViewController

@property (nonatomic, unsafe_unretained) PartModel *part;
@property (nonatomic, unsafe_unretained) id <PartDescriptionScreenProtocol> delegate;

@end

@protocol PartDescriptionScreenProtocol <NSObject>

- (void) packageStatusChangeForPart:(PartModel*)part;

@end
