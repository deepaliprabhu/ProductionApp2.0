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
    __weak IBOutlet UIView *_backgroundView;
}

- (void) layoutWithPerson:(UserModel*)user time:(int)time completed:(int)compl selected:(BOOL)s {

    _backgroundView.alpha = s;
    _operatorLabel.text = [[user.name componentsSeparatedByString:@" "] firstObject];
    
    if (time>0 && time<30*60)
        time = 30*60;
    if (compl>0 && compl<30*60)
        time = 30*60;
    
    for (int i=0; i<16; i++) {
        
        UIView *v = [_scheduleHolderView viewWithTag:i];
        int s = (i+1)*30*60;
        
        if (compl>=s)
            v.backgroundColor = ccolor(19, 167, 243);
        else if (time>=s)
            v.backgroundColor = ccolor(51, 204, 51);
        else
            v.backgroundColor = ccolor(204, 204, 204);
    }
}

@end
