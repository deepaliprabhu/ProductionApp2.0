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

- (void) layoutWithPerson:(UserModel*)user times:(NSArray*)times selected:(BOOL)s;

@end
