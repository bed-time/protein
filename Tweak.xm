#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Protein.h"
BOOL enabled;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Basic size and color things
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//group
%group Protein

@implementation UIColor (HexString)
+ (UIColor *)colorFromHexString:(NSString *)hexString {
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

//set the bar height
%hook SBReachabilitySettings
    -(void)setYOffsetFactor:(double)arg1 {
        %orig(-height / 1000);
    }
%end

//set color (this took over 2 hours, im dum dum, thanks ETHN (nahtedetihw) and Luki (luki120))
%hook SBReachabilityBackgroundView
	-(CGFloat)_displayCornerRadius{
		return 0;
	}

    -(void)willMoveToWindow:(id)arg1 {
        %orig;

        SBWallpaperEffectView *bottomWallpaperEffectView = MSHookIvar<SBWallpaperEffectView *>(self, "_bottomWallpaperEffectView");
		CGFloat thirds = UIScreen.mainScreen.bounds.size.width/3;

		for(UIView *view in bottomWallpaperEffectView.subviews) [view setAlpha:0];

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// The bars and buttons
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        UIView *ProteinBar = [[UIView alloc] initWithFrame: UIScreen.mainScreen.bounds];
        ProteinBar.backgroundColor = [UIColor colorFromHexString:bgCol];
		bottomWallpaperEffectView.clipsToBounds = false;
		ProteinBar.translatesAutoresizingMaskIntoConstraints = false;
        [bottomWallpaperEffectView addSubview:ProteinBar];
		
		[ProteinBar.topAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
		[ProteinBar.bottomAnchor constraintEqualToAnchor:MSHookIvar<UIView *>(self, "_homeGrabberView").bottomAnchor].active = YES;
		[ProteinBar.leadingAnchor constraintEqualToAnchor:bottomWallpaperEffectView.leadingAnchor].active = YES;
		[ProteinBar.trailingAnchor constraintEqualToAnchor:bottomWallpaperEffectView.trailingAnchor].active = YES;

        //buttons
        UIButton *back = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, thirds, height)];
        back.backgroundColor = [UIColor clearColor];
		back.translatesAutoresizingMaskIntoConstraints = false;
		[ProteinBar addSubview:back];
		
		[back.topAnchor constraintEqualToAnchor:ProteinBar.topAnchor].active = YES;
		[back.bottomAnchor constraintEqualToAnchor:ProteinBar.bottomAnchor].active = YES;
		[back.leadingAnchor constraintEqualToAnchor:ProteinBar.leadingAnchor].active = YES;
		[NSLayoutConstraint constraintWithItem:back attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:ProteinBar attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0].active = YES;

        UIButton *home = [[UIButton alloc] initWithFrame: CGRectMake(thirds, 0, thirds, height)];
        home.backgroundColor = [UIColor clearColor];
		home.translatesAutoresizingMaskIntoConstraints = false;
		[ProteinBar addSubview:home];
		
		[home.topAnchor constraintEqualToAnchor:ProteinBar.topAnchor].active = YES;
		[home.bottomAnchor constraintEqualToAnchor:ProteinBar.bottomAnchor].active = YES;
		[home.leadingAnchor constraintEqualToAnchor:back.trailingAnchor].active = YES;
		[NSLayoutConstraint constraintWithItem:home attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:ProteinBar attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0].active = YES;
        
        UIButton *multitasking = [[UIButton alloc] initWithFrame: CGRectMake(thirds + thirds, 0, thirds, height)];
        multitasking.backgroundColor = [UIColor clearColor];
		multitasking.translatesAutoresizingMaskIntoConstraints = false;
		[ProteinBar addSubview:multitasking];
		
		[multitasking.topAnchor constraintEqualToAnchor:ProteinBar.topAnchor].active = YES;
		[multitasking.bottomAnchor constraintEqualToAnchor:ProteinBar.bottomAnchor].active = YES;
		[multitasking.leadingAnchor constraintEqualToAnchor:home.trailingAnchor].active = YES;
		[NSLayoutConstraint constraintWithItem:multitasking attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:ProteinBar attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0].active = YES;


        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Button images
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		[back setImage:[UIImage imageWithContentsOfFile:@"Library/Application Support/Protein/back.png"] forState:UIControlStateNormal];
		back.imageView.contentMode = UIViewContentModeScaleAspectFit;

		[home setImage:[UIImage imageWithContentsOfFile:@"Library/Application Support/Protein/home.png"] forState:UIControlStateNormal];
		home.imageView.contentMode = UIViewContentModeScaleAspectFit;

		[multitasking setImage:[UIImage imageWithContentsOfFile:@"Library/Application Support/Protein/multi.png"] forState:UIControlStateNormal];
		multitasking.imageView.contentMode = UIViewContentModeScaleAspectFit;

    }

    -(void)setHomeGrabberAlpha:(double)arg1 {
        %orig(0);
    }

%end

//end group
%end //here



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// More prefs stuff
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

%ctor {
	NSDictionary *preferences = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"luv.bedtime.proteinprefs"];

	BOOL enabled = [preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : TRUE;

	height = [preferences objectForKey:@"height"] ? [[preferences objectForKey:@"height"] floatValue] : 50;
	bgCol = [preferences objectForKey:@"bgCol"];
	fgCol = [preferences objectForKey:@"fgCol"];

	if (enabled) {
		%init(Protein);
	}

}