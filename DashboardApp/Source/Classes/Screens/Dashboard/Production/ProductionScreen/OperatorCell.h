//
//  OperatorCell.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 24/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface OperatorCell : UITableViewCell

- (void) layoutWithPerson:(UserModel*)user time:(int)time completed:(int)compl selected:(BOOL)s;

@end
