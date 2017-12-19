//
//  DailyLogRawScreen.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 19/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "DailyLogRawScreen.h"
#import "DayLogModel.h"

@interface DailyLogRawScreen ()

@end

@implementation DailyLogRawScreen {
    
    __weak IBOutlet UITextView *_textView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 500);
    
    NSMutableString *str = [NSMutableString string];
    for (DayLogModel *d in _days) {
        
        NSString *s = [d.data description];
        [str appendString:s];
        [str appendString:@"\n"];
    }
    
    _textView.text = str;
}

@end
