#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>

@interface UIDevice()
    +(BOOL)_hasHomeButton;
@end

@interface SBReachabilityWindow : UIWindow
@end

@interface SBWallpaperEffectView : UIVisualEffectView
@property (nonatomic,retain) UIView * colorTintView;
@end

@interface SBReachabilityBackgroundView : UIView
@end

static CGFloat height;
NSString *bgCol;
NSString *fgCol;

UIColor *BarColor;
UIColor *ButtonColor;

@implementation UIColor (HexString)

+(UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red   = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue  = ((baseValue >> 8)  & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0)  & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end