//
//  ProcessCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "ProcessCell.h"
#import "Defines.h"

typedef enum  {
    DarkTheme,
    RedTheme
} ProcessCellThemeColor;

@implementation ProcessCell {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_processNoLabel;
    __weak IBOutlet UILabel *_processedLabel;
    __weak IBOutlet UILabel *_rejectedLabel;
    __weak IBOutlet UIImageView *_shapeView;
    __weak IBOutlet UIView *_bgView;
}

- (void) layoutWith:(ProcessModel*)process {
    
    _titleLabel.text = process.processName;
    _processedLabel.text = [NSString stringWithFormat:@"%d", process.processed];
    _rejectedLabel.text = [NSString stringWithFormat:@"%d", process.rejected];
    _processNoLabel.text = process.processNo;
    
    [self layoutWithTheme:(process.rejected==0 ? DarkTheme : RedTheme)];
}

- (void) setSelected:(BOOL)selected {
    
    _shapeView.alpha = selected;
    _bgView.alpha = selected;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    _shapeView.alpha = selected;
    _bgView.alpha = selected;
}

- (void) layoutWithTheme:(ProcessCellThemeColor)t {
 
    UIColor *c;
    if (t == DarkTheme) {
        c = [UIColor blackColor];
    } else {
        c = ccolor(240, 8, 25);
    }
    _titleLabel.textColor = c;
    _processedLabel.textColor = c;
    _rejectedLabel.textColor = c;
    _processNoLabel.textColor = c;
}

@end
