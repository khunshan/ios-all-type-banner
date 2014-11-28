//
//  Banner.m
//  Tune.pk
//
//  Created by Khunshan on 11/08/2014.
//  Copyright (c) 2014 Muneeb. All rights reserved.
//

//#define bannerWidthGlobal 360.0f

#include "AppDelegate.h"
#import "Banner.h"

#define bannerOffsetY 40

#define titleOffsetY 3.0f
#define titleHeight 15.0f

#define contentOffsetY 4.0f
#define contentHeight 40.0f // 15f to 20f = 1 line

#define bannerStandbyDuration 5.0f
#define bannerOutDuration 0.75f
#define bannerInDurationGlobal 0.35f

#define bannerHeight (2*titleOffsetY + titleHeight + contentOffsetY + contentHeight)


#define SCREEN_WIDTH_BELOW_IOS8 ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define SCREEN_HEIGHT_BELOW_IOS8 ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)



#define isIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#define SCREEN_WIDTH_ABOVE_IOS8 [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT_ABOVE_IOS8 [[UIScreen mainScreen] bounds].size.height


#define LRW_Autoresize_macro UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth


@implementation Banner
@synthesize autoDismiss;

int bannerWidth = 0;
float bannerInDuration = bannerInDurationGlobal;
NSInteger orientation;

CGRect firstFrame;
CGRect finalFrame;
CGRect removalFrame;
float angle;

float mySCREEN_WIDTH;
float mySCREEN_HEIGHT;
float myM_PI;
int LRW_Autoresize;

NSString* const kDownloadingQueued = @"Download Queued!";
NSString* const kDownloadingComplete = @"Download Completed!";
NSString* const kUploadingQueued = @"Upload Queued!";
NSString* const kUploadingComplete = @"Upload Completed!";
NSString* const kError = @"Error!";
NSString* const kResponse = @"Response!";
NSString* const kShare = @"Share!";
NSString* const kNetFailure = @"Network Failure!";
NSString* const kAuthentication = @"Authentication!";
NSString* const kComment = @"Comment!";


-(void)doSetup{
    
    self.layer.cornerRadius = 4.0;
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.955f;
    self.autoresizingMask = LRW_Autoresize;
    
    autoDismiss = YES;
    
    
    LRW_Autoresize = LRW_Autoresize_macro;
    
    
    if(!(isIOS8)){
        
        bannerWidth = [[UIScreen mainScreen] bounds].size.width / 1.1f; //Because ios7 not working with autoresizing. SO fixed the banenrWidth.
        
        [self setFrameAndRotationForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
        mySCREEN_HEIGHT = SCREEN_HEIGHT_BELOW_IOS8;
        mySCREEN_WIDTH = SCREEN_WIDTH_BELOW_IOS8;
        myM_PI = M_PI;
    }
    
    else {
        [self setFrameAndRotationForOrientation:1];
        mySCREEN_HEIGHT = SCREEN_HEIGHT_ABOVE_IOS8;
        mySCREEN_WIDTH = SCREEN_WIDTH_ABOVE_IOS8;
        myM_PI = 0;
        bannerWidth = mySCREEN_WIDTH / 1.1f;
        
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doSetup];
    }
    
    return self;
}


- (id)initWithTitle:(NSString *)title contentText:(NSString *)content{
    if (self = [super init]) {
        [self doSetup];
        
        [self doTitleLayout];
        [self doContentLayout];
        [self doCancelButtonLayout];
        
        [self addSubview:self.alertTitleLabel];
        [self addSubview:self.alertContentLabel];
        [self addSubview:self.cancel];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        
        [self.cancel addTarget:self action:@selector(bannerDismissed) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *ut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTouched)];
        [self addGestureRecognizer:ut];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
    }
    return self;
}

-(void) doTitleLayout{
    self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleOffsetY, bannerWidth, titleHeight)];
    self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
    self.alertTitleLabel.backgroundColor = [UIColor clearColor]; //added for < ios7
    
}

-(void) doContentLayout{
    CGFloat contentLabelWidth = bannerWidth - 16;
    
    self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((bannerWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame) + contentOffsetY, contentLabelWidth, contentHeight)];
    self.alertContentLabel.numberOfLines = 0;
    self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.alertContentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    self.alertContentLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.alertContentLabel.backgroundColor = [UIColor clearColor]; //added for < ios7
    
}

-(void) doCancelButtonLayout{
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    self.cancel.frame = CGRectMake(CGRectGetMaxX(self.frame) - 23, CGRectGetMaxY(self.frame) + 2, 22, 22);
    self.cancel.backgroundColor = [UIColor lightGrayColor];
    self.cancel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
}

-(void)show{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backView.backgroundColor = [UIColor clearColor];
    self.backImageView = backView;
    
    
    //CGRect beforeFrame = CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  - bannerHeight, bannerWidth, bannerHeight);
    self.transform = CGAffineTransformMakeRotation(angle);
    self.frame = firstFrame;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:self];
    
    if(autoDismiss){
        [NSTimer scheduledTimerWithTimeInterval:bannerStandbyDuration
                                         target:self
                                       selector:@selector(bannerDismissed)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    if (isIOS8) {
        self.alertContentLabel.autoresizingMask = LRW_Autoresize;
        self.alertTitleLabel.autoresizingMask = LRW_Autoresize;
    }
    
}

#pragma mark - UIView methods

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    if (!self.backImageView) {
        CGRect frame = [[UIApplication sharedApplication].keyWindow bounds];
        self.backImageView = [[UIView alloc] initWithFrame:frame];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    //~Starting Animation
    
    //CGRect afterFrame = CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  bannerOffsetY , bannerWidth, bannerHeight);
    [UIView animateWithDuration:bannerInDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(angle);
        self.frame = finalFrame;
    } completion:^(BOOL finished) {
        //NSLog(@"Banner displayed");
    }];
    [super willMoveToSuperview:newSuperview];
}



- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    
    [UIView animateWithDuration:bannerOutDuration delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = removalFrame;
        self.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Touch/Dismiss blocks

- (void)bannerTouched{
    //NSLog(@"~Banner touched");
    if (self.touchBlock) {
        self.touchBlock();
    }
    
    //Added to dismiss banner (all) immediately it is touced.
    [Banner removeAllBanners];
}

- (void)bannerDismissed
{
    if (!self.superview) return; //Already removed from superview. Added to facilitate dismiss on Touch
    
    //NSLog(@"~Banner dismissed");
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark -

+(BOOL)removeAllBanners{
    @try {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        for (UIView* subView in appDelegate.window.subviews) {
            if([subView isKindOfClass:[Banner class]])
                [(Banner*) subView removeFromSuperview];
        }
        //NSLog(@"~All Banners Removed.");
        return YES;
    }
    @catch (NSException *exception) {
        //NSLog(@"~All Banners NOT Removed.");
        return NO;
    }
    @finally {
        nil;
    }
}

+(BOOL)isBannerDisplayed
{
    BOOL hasBanner = NO;
    @try {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        for (UIView* subView in appDelegate.window.subviews) {
            if([subView isKindOfClass:[Banner class]]) {
                hasBanner = true;
                break;
            }
        }
        //NSLog(@"~All Banners Removed.");
    }
    @catch (NSException *exception) {
        //NSLog(@"~All Banners NOT Removed.");
        hasBanner = false;
    }
    return hasBanner;
}

-(void)rotationChanged:(NSNotification *)notification{
    orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self orientationChanged:orientation];
}

-(void) orientationChanged:(NSInteger)orientation {
    
    mySCREEN_WIDTH = ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height);
    
    mySCREEN_HEIGHT = ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width);
    
    NSLog(@"screen width dude: %.2f", mySCREEN_WIDTH);
    NSLog(@"screen height dude: %.2f", mySCREEN_HEIGHT);
    
    switch (orientation) {
        case 1:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [self setTransform:CGAffineTransformMakeRotation (0)];
            [self setFrame: CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  bannerOffsetY , bannerWidth, bannerHeight)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            [UIView commitAnimations];
            [self setFrameAndRotationForOrientation:1];
            break;
        case 2:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [self setTransform:CGAffineTransformMakeRotation (myM_PI)];
            [self setFrame:CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  mySCREEN_HEIGHT - (3*bannerOffsetY) , bannerWidth, bannerHeight)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            [UIView commitAnimations];
            [self setFrameAndRotationForOrientation:2];
            break;
        case 3:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [self setTransform:CGAffineTransformMakeRotation (myM_PI / 2)];
            [self setFrame: CGRectMake(mySCREEN_HEIGHT - (3*bannerOffsetY), (mySCREEN_WIDTH - bannerWidth )* 0.5 , bannerHeight, bannerWidth)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [UIView commitAnimations];
            [self setFrameAndRotationForOrientation:3];
            break;
        case 4:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4f];
            [self setTransform:CGAffineTransformMakeRotation (- myM_PI / 2)];
            [self setFrame: CGRectMake(bannerOffsetY, (mySCREEN_WIDTH - bannerWidth )* 0.5 , bannerHeight, bannerWidth)];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            [UIView commitAnimations];
            [self setFrameAndRotationForOrientation:4];
            break;
        default:
            [self orientationChanged:1];
            break;
    }
}

- (void)setFrameAndRotationForOrientation:(NSInteger)orientation{
    //NSLog(@"Orientation is: %ld", (long)orientation);
    switch (orientation) {
        case 1:
            firstFrame =    CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  - bannerHeight, bannerWidth, bannerHeight);
            finalFrame =    CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  bannerOffsetY , bannerWidth, bannerHeight);
            removalFrame =  CGRectMake((mySCREEN_WIDTH * 2),  bannerOffsetY , bannerWidth, bannerHeight);
            angle = 0;
            bannerInDuration = bannerInDurationGlobal;
            break;
        case 2:
            firstFrame =    CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  mySCREEN_HEIGHT + bannerHeight , bannerWidth, bannerHeight);
            finalFrame =    CGRectMake((mySCREEN_WIDTH - bannerWidth )* 0.5,  mySCREEN_HEIGHT - (3*bannerOffsetY) , bannerWidth, bannerHeight);
            removalFrame =  CGRectMake(-(mySCREEN_WIDTH * 2),  mySCREEN_HEIGHT - (3*bannerOffsetY) , bannerWidth, bannerHeight);
            angle = myM_PI;
            bannerInDuration = bannerInDurationGlobal;
            break;
        case 3:
            firstFrame =    CGRectMake(mySCREEN_WIDTH , (mySCREEN_WIDTH - bannerWidth )* 0.5 , bannerHeight, bannerWidth);
            finalFrame =    CGRectMake(mySCREEN_HEIGHT - (3*bannerOffsetY), (mySCREEN_WIDTH - bannerWidth )* 0.5 , bannerHeight, bannerWidth);
            removalFrame =  CGRectMake(mySCREEN_HEIGHT - (3*bannerOffsetY), mySCREEN_WIDTH * 2 , bannerHeight, bannerWidth);
            angle = myM_PI / 2;
            bannerInDuration = bannerInDurationGlobal * 2.5f;
            break;
        case 4:
            firstFrame =    CGRectMake(-(mySCREEN_WIDTH), -(mySCREEN_WIDTH - bannerWidth )* 0.5, bannerHeight, bannerWidth);
            finalFrame =    CGRectMake(bannerOffsetY, (mySCREEN_WIDTH - bannerWidth )* 0.5 , bannerHeight, bannerWidth);
            removalFrame =  CGRectMake(bannerOffsetY, -(mySCREEN_WIDTH * 2), bannerHeight, bannerWidth);
            angle = - myM_PI / 2;
            bannerInDuration = bannerInDurationGlobal * 2.5f;
            break;
        default:
            [self setFrameAndRotationForOrientation:1];
            break;
    }
}

@end
