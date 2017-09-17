//
//  Defines.h
//
//  Created by Andrei Ghidoarca on 11/26/12.
//  Copyright (c) 2012 Gambit. All rights reserved.
//

/// numbers universal valid

#define kMetersToFeetConversion     3.28084

///////////////////////////

#define APPDEL (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define SINGLETON(__sharedInstance__)       static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{      \
\
__sharedInstance__ = [[self alloc] init];   \
\
});                               \
\
return __sharedInstance__;

#define cf                                   CGRect
#define ccf(__X__,__Y__,__W__,__H__)         CGRectMake(__X__,__Y__,__W__,__H__)
#define cp                                   CGPoint
#define ccp(__X__,__Y__)                     CGPointMake(__X__,__Y__)
#define cs                                   CGSize
#define ccs(__W__,__H__)                     CGSizeMake(__W__,__H__)
#define ccFont(__NAME__,__SIZE__)            [UIFont fontWithName:__NAME__ size:__SIZE__]
#define ccSFont(__SIZE__)                    [UIFont systemFontOfSize:__SIZE__]
#define ccSBFont(__SIZE__)                   [UIFont boldSystemFontOfSize:__SIZE__]
#define cci                                  UIImage*
#define ccimg(__IMAGE__)                     [UIImage imageNamed:__IMAGE__]
#define cc                                   UIColor*
#define cclear                               [UIColor clearColor]
#define ccred                                [UIColor redColor]
#define ccgreen                              [UIColor greenColor]
#define ccgrey                               [UIColor grayColor]
#define ccorange                             [UIColor orangeColor]
#define ccwhite                              [UIColor whiteColor]
#define ccblack                              [UIColor blackColor]
#define ccblue                               [UIColor blueColor]

#define cfcolor(__R__,__G__,__B__)            [UIColor colorWithRed:__R__ green:__G__ blue:__B__ alpha:1]
#define ccolor(__R__,__G__,__B__)            [UIColor colorWithRed:__R__/255.0f green:__G__/255.0f blue:__B__/255.0f alpha:1]
#define ccolora(__R__,__G__,__B__,__ALPHA__) [UIColor colorWithRed:__R__/255.0f green:__G__/255.0f blue:__B__/255.0f alpha:__ALPHA__]
#define fcolor(__R__,__G__,__B__,__ALPHA__)  [UIColor colorWithRed:__R__ green:__G__ blue:__B__ alpha:__ALPHA__]

#define cstrm                                NSMutableString*
#define cstr                                 NSString*
#define cstrf(fmt, ...)                      [NSString stringWithFormat:fmt, ##__VA_ARGS__]
#define seq(__STRING1__,__STRING2__)         [__STRING1__ isEqualToString:__STRING2__]

#define rToString(__RECT__)                  NSStringFromCGRect(__RECT__)
#define pToString(__POINT__)                 NSStringFromCGPoint(__POINT__)
#define sToString(__SIZE__)                  NSStringFromCGSize(__SIZE__)

// properties

#define __pru                                    @property (nonatomic, unsafe_unretained)
#define __prs                                    @property (nonatomic, strong)
#define __pd(__PROTOCOL__)                       __pru id <__PROTOCOL__> delegate;
#define __pds(__PROTOCOL__)                       __prs id <__PROTOCOL__> delegate;
#define __pcd(__PROTOCOL__, __PROPERTY_NAME__)   __pru id <__PROTOCOL__> __PROPERTY_NAME__;

// blocks

#define __bundle(__NAME__,__INDEX__)          [[NSBundle mainBundle] loadNibNamed:__NAME__ owner:nil options:nil][__INDEX__]
#define __bundle0(__NAME__)                   [[NSBundle mainBundle] loadNibNamed:__NAME__ owner:nil options:nil][0]

#define __asyncGlobal(block) \
\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block); \

#define __asyncMain(block) \
\
dispatch_async(dispatch_get_main_queue(), block); \


#define __after(__DELAY__, __BLOCK__)                                        \
double delayInSeconds = __DELAY__;     \
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));  \
dispatch_after(popTime, dispatch_get_main_queue(), __BLOCK__);                                         \

// dispatches

// types
#define carr                                NSArray *
#define cmarr                               NSMutableArray *
#define cd                                  NSDictionary *
#define cmd                                 NSMutableDictionary *
#define ccn                                 NSNumber *

// numbers

#define hScr                                [UIScreen mainScreen].bounds.size.height
#define wScr                                [UIScreen mainScreen].bounds.size.width
#define isLandscape()                       UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])
#define isPortrait()                        UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define isRetina()                          [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && \
([UIScreen mainScreen].scale == 2.0)

// bools

#define iPad                                ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define iPhone                              ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define iPhone5                             (iPhone && [UIScreen mainScreen].bounds.size.height > 480)

// objc
#define uOut                                __weak IBOutlet
#define act                                 IBAction

// methods

#define NSLogFonts     [[UIFont familyNames] enumerateObjectsUsingBlock:^(NSString *family, NSUInteger idx, BOOL *stop) { \
\
NSLog(@"----------------------------"); \
NSLog(@"FAMILY %@",family);             \
\
[[UIFont  fontNamesForFamilyName:family] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { \
\
NSLog(@"%@",obj)                \
\
;}];                                    \
\
}];

#define __notify(__NAME__)                  [[NSNotificationCenter defaultCenter] postNotificationName:__NAME__ object:nil];
#define __notifyObj(__NAME__, __OBJ__)      [[NSNotificationCenter defaultCenter] postNotificationName:__NAME__ object:__OBJ__];

#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define __CREATEVIEWH(__CLASS__) + (__CLASS__*) createView;
#define __CREATEVIEW(__CLASS__, __NIB__,__INDEX__)   + (__CLASS__*) createView \
{ \
UINib *nib = [UINib nibWithNibName:__NIB__ bundle:nil]; \
\
__CLASS__ *view = [nib instantiateWithOwner:nil options:nil][__INDEX__]; \
\
return view; \
}

#define __ADDVIEWH  - (void) addTo:(UIView*)superview;
#define __ADDVIEW   - (void) addTo:(UIView*)superview \
{                                                     \
[superview addSubview:self];                      \
}

// images

#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568", image] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])


///////////////////////// System version //////////////////////////

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
