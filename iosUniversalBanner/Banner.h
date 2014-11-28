//
//  Banner.h
//  Tune.pk
//
//  Created by Khunshan on 11/08/2014.
//  Copyright (c) 2014 Muneeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Banner : UIView

//~Some default label constats
extern NSString* const kDownloadingQueued;
extern NSString* const kDownloadingComplete;
extern NSString* const kError;
extern NSString* const kResponse;
extern NSString* const kShare;
extern NSString* const kNetFailure;
extern NSString* const kAuthentication;
extern NSString* const kComment;
extern NSString* const kUploadingQueued;
extern NSString* const kUploadingComplete;


//~Class Methods
- (id)initWithTitle:(NSString *)title contentText:(NSString *)content;
- (void)show;
+ (BOOL)removeAllBanners;
+ (BOOL)isBannerDisplayed;

//~Class Properties
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) dispatch_block_t touchBlock;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, strong) UIButton *cancel;
@property (atomic) BOOL autoDismiss; //~default is YES

@end
