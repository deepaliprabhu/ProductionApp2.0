//
//  ScheduleView.h
//  ProductionMobile
//
//  Created by Andrei Ghidoarca on 19/02/2018.
//  Copyright © 2018 Andrei Ghidoarca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface ScheduleView : UIView

__CREATEVIEWH(ScheduleView);

+ (CGFloat) width;
+ (CGFloat) height;

- (void) layoutScheduleWithData:(NSArray*)times isSelected:(BOOL)s;

@end
