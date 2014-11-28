//
//  ViewController.m
//  iosUniversalBanner
//
//  Created by ks on 29/11/2014.
//  Copyright (c) 2014 Khunshan Ahmad. All rights reserved.
//

#import "ViewController.h"
#import "Banner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAGAIN:(id)sender {
    
    Banner* ban = [[Banner alloc] initWithTitle:@"Yo" contentText:@"https://github.com/khunshan/ios-all-type-banner.git"];
    
        ban.touchBlock = ^(void) {
            NSLog(@"*** Dont you dare touching me ***");
        };
    
        ban.dismissBlock = ^(void) {
            NSLog(@"--- Banner dismissed successfully ---");
        };
    
        ban.autoDismiss = NO;
    
    [ban show];
    
}
@end
