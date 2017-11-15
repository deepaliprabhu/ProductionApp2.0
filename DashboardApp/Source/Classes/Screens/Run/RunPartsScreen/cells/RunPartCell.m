//
//  RunPartCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 14/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "RunPartCell.h"

@implementation RunPartCell
{
    __unsafe_unretained IBOutlet UILabel *_orderLabel;
    __unsafe_unretained IBOutlet UILabel *_runName;
    __unsafe_unretained IBOutlet UILabel *_productIDLabel;
    __unsafe_unretained IBOutlet UILabel *_runSizeLabel;
    __unsafe_unretained IBOutlet UILabel *_qtyLabel;
    __unsafe_unretained IBOutlet UIView  *_bgView;
}

+ (CGFloat) height {
    return 34;
}

- (void) layoutWith:(RunModel*)run at:(int)index {
    
    if (index%2 == 0) {
        _bgView.backgroundColor = [UIColor whiteColor];
    } else {
        _bgView.backgroundColor = [UIColor clearColor];
    }
    
    _orderLabel.text = [NSString stringWithFormat:@"%d.", index+1];
    _runName.text = [NSString stringWithFormat:@"%@: %@", run.runID, run.productName];
    _productIDLabel.text = run.productID;
    _runSizeLabel.text = run.runSize;
    _qtyLabel.text = run.qty;
}

@end
