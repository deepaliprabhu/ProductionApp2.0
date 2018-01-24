//
//  OperatorCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 24/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "OperatorCell.h"

@implementation OperatorCell {
    __weak IBOutlet UILabel *_operatorLabel;
}

- (void) layoutWithPerson:(UserModel*)user {
    _operatorLabel.text = user.name;
}

@end
