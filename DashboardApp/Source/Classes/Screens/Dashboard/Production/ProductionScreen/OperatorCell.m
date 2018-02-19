//
//  OperatorCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 24/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorCell.h"
#import "Defines.h"
#import "ScheduleView.h"
#import "LayoutUtils.h"

@implementation OperatorCell {
    
    __weak IBOutlet UILabel *_operatorLabel;
    __weak IBOutlet UIView *_backgroundView;
}

- (void) layoutWithPerson:(UserModel*)user times:(NSArray*)times selected:(BOOL)s {

    _backgroundView.alpha = s;
    _operatorLabel.text = [[user.name componentsSeparatedByString:@" "] firstObject];
  
    [[self viewWithTag:100] removeFromSuperview];
    [self addScheduleViewWith:times selected:s];
}

- (void) addScheduleViewWith:(NSArray*)times selected:(BOOL)s {
    
    ScheduleView *scheduleView = [ScheduleView createView];
    scheduleView.userInteractionEnabled = false;
    scheduleView.translatesAutoresizingMaskIntoConstraints = false;
    [LayoutUtils addContraintWidth:[ScheduleView width] andHeight:[ScheduleView height] forView:scheduleView];
    [self addSubview:scheduleView];
    
    [LayoutUtils addTopConstraintFromView:scheduleView toView:self constant:9];
    [LayoutUtils addTrailingConstraintFromView:scheduleView toView:self constant:-20];
    
    [scheduleView layoutScheduleWithData:times isSelected:s];
}

@end
