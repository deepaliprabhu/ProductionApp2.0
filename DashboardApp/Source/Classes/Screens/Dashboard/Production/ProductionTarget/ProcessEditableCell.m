//
//  ProcessEditableCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessEditableCell.h"

@implementation ProcessEditableCell {
    
    __weak IBOutlet UILabel *_processLabel;
    __weak IBOutlet UILabel *_targetLabel;
    __weak IBOutlet UILabel *_statusLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_operatorLabel;
}

- (void) layoutWithProcess:(ProcessModel*)process {
    
    _processLabel.text = process.processName;
    _timeLabel.text = [self timeForSeconds:[process.processingTime intValue]];
}

- (NSString*) timeForSeconds:(int)time {
    
    if (time == 0)
        return @"-";
    else {
        
        time = (time/60)*60;
        int h = time/3600;
        int min = (time%3600)/60;
        if (h == 0) {
            return [NSString stringWithFormat:@"%dm", min];
        } else {
            return [NSString stringWithFormat:@"%dh %dm", h, min];
        }
    }
}

@end
