//
//  TiBaseViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiBaseViewController.h"
#import "TiWebColor.h"

@interface TiBaseViewController ()

@end

@implementation TiBaseViewController

- (void)dealloc
{
    RELEASE_TO_NIL(_method);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [[self view] setBackgroundColor:[TiWebColor webColorNamed:@"#CCC"]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUpNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDownNotification:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear: animated];
}

-(void)onKeyboard:(CGFloat)top
{
    // for subclass    
}

-(void)keyboardUpNotification:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    CGRect keyboardFrameRect = [[userInfo valueForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        [self onKeyboard: keyboardFrameRect.size.width];
    } else {
        [self onKeyboard: keyboardFrameRect.size.height];
    }
}

-(void)keyboardDownNotification:(NSNotification *)notification
{
    [self onKeyboard: 0];
}

@end
