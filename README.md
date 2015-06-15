ios-all-type-banner
======================

A Mac OS style banner written in Objective C that respects iOS7 &amp; iOS8 for iOS in ALL orinetations by adding a UIView in UIWindow of UIApplication. It adds as another view top of ALL. Plus, uses blocks for dismiss and touch events. You like it?



<img src="http://imgur.com/nh7AvVb"/>


Import Banner.h file in your class.

	#import "Banner.h"

And use this code to dart a banner on screen.

    Banner* ban = [[Banner alloc] initWithTitle:@"Success" contentText:@"You know what to do with a big fat banner?"];
    
        ban.touchBlock = ^(void) {
            NSLog(@"*** Dont you dare touching me ***");
        };
    
        ban.dismissBlock = ^(void) {
            NSLog(@"--- Banner dismissed successfully ---");
        };
    
        ban.autoDismiss = NO;
    
    [ban show];
    

That's sufficient for a banner to display. More Advance methods:

	- (id)initWithTitle:(NSString *)title contentText:(NSString *)content;
	- (void)show;
	+ (BOOL)removeAllBanners;
	+ (BOOL)isBannerDisplayed;


Some pre defined constants added.

	NSString* const kError = @"Error!";
	NSString* const kResponse = @"Response!";
	NSString* const kShare = @"Share!";
	NSString* const kNetFailure = @"Network Failure!";
	NSString* const kAuthentication = @"Authentication!";
	NSString* const kComment = @"Comment!";



