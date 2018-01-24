//
//  ProductionRunCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 25/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProductionRunCell.h"

@implementation ProductionRunCell {
    __weak IBOutlet UILabel *_runLabel;
    __unsafe_unretained Run *_run;
}

- (void) layoutWithRun:(Run*)r {
    
    _run = r;
    _runLabel.text = [NSString stringWithFormat:@"%d", [r getRunId]];
}

- (IBAction) viewButtonTapped {
    [_delegate showDetailsForRun:_run];
}

@end
