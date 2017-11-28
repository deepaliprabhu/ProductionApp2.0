//
//  AddCommentScreen.h
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 23/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartModel.h"
#import "CommentModel.h"
#import "Run.h"

@protocol AddCommentProtocol;

@interface AddCommentScreen : UIViewController

@property (nonatomic, unsafe_unretained) id <AddCommentProtocol> delegate;
@property (nonatomic, unsafe_unretained) PartModel *part;
@property (nonatomic, unsafe_unretained) Run *run;

@end

@protocol AddCommentProtocol <NSObject>

- (void) newCommentAdded:(CommentModel*)comment;

@end
