//
//  LockConfirmationHeaderView.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 12/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "LockConfirmationHeaderView.h"
#import "Defines.h"

@implementation LockConfirmationHeaderView {
    
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_indexLabel;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_neededLabel;
    __weak IBOutlet UILabel *_allocatedLabel;
    __weak IBOutlet UILabel *_priceLabel;
}

+ (CGFloat) height {
    return 30;
}

+ (LockConfirmationHeaderView*) createView {
    
    UINib *nib = [UINib nibWithNibName:@"LockConfirmationHeaderView" bundle:nil];
    LockConfirmationHeaderView *view = [nib instantiateWithOwner:nil options:nil][0];
    return view;
}

- (void) layoutWithPart:(PartModel*)part atIndex:(int)index allocated:(int)all price:(float)pr {
    
    _indexLabel.text = [NSString stringWithFormat:@"%d.", index+1];
    _nameLabel.text = part.part;
    _neededLabel.text = [NSString stringWithFormat:@"%d", part.shortQty];
    _allocatedLabel.text = [NSString stringWithFormat:@"%d", all];
    _priceLabel.text = [NSString stringWithFormat:@"%.4f$", pr];
    
    if (part.shortQty == all) {
        _bgView.backgroundColor = ccolor(67, 194, 81);
    } else {
        _bgView.backgroundColor = ccolor(233, 46, 40);
    }
}

@end
