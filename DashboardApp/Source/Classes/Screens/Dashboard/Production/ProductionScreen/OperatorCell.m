//
//  OperatorCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 24/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorCell.h"
#import "Defines.h"

@implementation OperatorCell {
    __weak IBOutlet UILabel *_operatorLabel;
    __weak IBOutlet UIView *_scheduleHolderView;
}

- (void) layoutWithPerson:(UserModel*)user time:(int)time {
    
    _operatorLabel.text = user.name;
    
    for (int i=0; i<16; i++) {
        
        UIView *v = [_scheduleHolderView viewWithTag:i];
        int s = (i+1)*30*60;
        if ((time >= s && time > 0) || (i==0 && time>0))
            v.backgroundColor = ccolor(51, 204, 51);
        else
            v.backgroundColor = ccolor(204, 204, 204);
    }
}

@end
