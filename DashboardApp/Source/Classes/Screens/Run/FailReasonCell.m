//
//  FailReasonCell.m
//  DashboardApp
//
//  Created by Andrei Ghidoarca on 29/12/2017.
//  Copyright © 2017 Deepali Prabhu. All rights reserved.
//

#import "FailReasonCell.h"
#import "LayoutUtils.h"

@implementation FailReasonCell {
    __weak IBOutlet UILabel *_pcbLabel;
    __weak IBOutlet UILabel *_panelLabel;
    __weak IBOutlet UILabel *_commentsLabel;
    __weak IBOutlet UILabel *_verdictLabel;
}

+ (CGFloat) heightForFail:(NSDictionary*)fail {
    
    UIFont *f = [UIFont fontWithName:@"Roboto-Light" size:17];
    CGFloat h1 = [LayoutUtils heightForText:fail[@"reworkComment"] withFont:f andMaxWidth:182 centerAligned:false];
    CGFloat h2 = [LayoutUtils heightForText:[FailReasonCell reasonsFrom:fail[@"verdict"]] withFont:f andMaxWidth:253 centerAligned:false];
    
    return MAX(MAX(h1, h2), 34);
}

- (void) layoutWithFail:(NSDictionary*)fail {
 
    _pcbLabel.text = fail[@"pcbId"];
    _panelLabel.text = fail[@"panelId"];
    
    NSString *comment = fail[@"reworkComment"];
    if (comment == nil)
        _commentsLabel.text = @"-";
    else
        _commentsLabel.text = comment;
    
    _verdictLabel.text = [FailReasonCell reasonsFrom:fail[@"verdict"]];
}

+ (NSString*) reasonsFrom:(NSString*)s {
    
    NSArray *arr = [s componentsSeparatedByString:@","];
    if (arr.count > 1) {
        NSMutableString *str = [NSMutableString new];
        for (NSString *r in arr) {
            [str appendString:r];
            [str appendString:@"\n"];
        }
        return str;
    } else {
        return s;
    }
}

@end
