//
//  LockConfirmationHeaderView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LockConfirmationHeaderView.h"

@implementation LockConfirmationHeaderView {
    
    __weak IBOutlet UILabel *_indexLabel;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_qtyLabel;
    __weak IBOutlet UIView *_backgroundView;
}

+ (LockConfirmationHeaderView*) createView
{
    UINib *nib = [UINib nibWithNibName:@"LockConfirmationHeaderView" bundle:nil];
    LockConfirmationHeaderView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) layoutWithPart:(PartModel*)part atIndex:(int)index {
    
    _indexLabel.text = [NSString stringWithFormat:@"%d", index];
    _nameLabel.text = part.part;
}

@end
