//
//  FailHeaderCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FailHeaderCell.h"

@implementation FailHeaderCell {
    __weak IBOutlet UILabel *_reasonLabel;
}

+ (CGFloat) heightFor:(NSString*)text {

    return 0;
}

- (void) layoutWithReason:(NSString*)reason {
    _reasonLabel.text = reason;
}

@end
