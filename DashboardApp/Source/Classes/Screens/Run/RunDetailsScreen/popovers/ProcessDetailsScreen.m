//
//  ProcessDetailsScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 04/01/2018.
//  Copyright © 2018 Deepali Prabhu. All rights reserved.
//

#import "ProcessDetailsScreen.h"
#import "LayoutUtils.h"

@interface ProcessDetailsScreen ()

@end

@implementation ProcessDetailsScreen {
    __weak IBOutlet UITextView *_textView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _textView.text = _details;
    
    UIFont *f = [UIFont fontWithName:@"Roboto-Regular" size:15];
    CGFloat h = [LayoutUtils heightForText:_details withFont:f andMaxWidth:500 centerAligned:false];
    if (h < 30)
        h = 30;
    h+=10;
    self.preferredContentSize = CGSizeMake(500, h);
}

@end
