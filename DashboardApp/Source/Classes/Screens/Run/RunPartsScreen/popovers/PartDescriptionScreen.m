//
//  PartDescriptionScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 28/11/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "PartDescriptionScreen.h"
#import "LayoutUtils.h"
#import "Defines.h"

@interface PartDescriptionScreen ()

@end

@implementation PartDescriptionScreen
{
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_noDescriptionLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_partDescription.length == 0) {
        
        _noDescriptionLabel.alpha = 1;
        self.preferredContentSize = CGSizeMake(300, 100);
    }
    else {
        
        _noDescriptionLabel.alpha = 0;
        _textView.text = _partDescription;
        
        CGFloat h = [LayoutUtils heightForText:_partDescription withFont:ccFont(@"Roboto-Regular", 15) andMaxWidth:300 centerAligned:false] + 10;
        if (h < 30)
            h = 30;
        else if (h > 600)
            h = 600;
        self.preferredContentSize = CGSizeMake(300, h);
    }
}

@end
