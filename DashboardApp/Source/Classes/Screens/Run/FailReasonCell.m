//
//  FailReasonCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FailReasonCell.h"

@implementation FailReasonCell {
    __weak IBOutlet UILabel *_pcbLabel;
    __weak IBOutlet UILabel *_panelLabel;
}

- (void) layoutWithFail:(NSDictionary*)fail {
 
    _pcbLabel.text = fail[@"pcbId"];
    _panelLabel.text = fail[@"panelId"];
}

@end
