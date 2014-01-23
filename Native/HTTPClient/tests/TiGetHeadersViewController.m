//
//  TiOtherGetViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/20/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiGetHeadersViewController.h"
#import "TiHTTPResponse.h"
@interface TiGetHeadersViewController ()

@end

@implementation TiGetHeadersViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setMethod:@"GET"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Response Headers Test"];
}

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant:top + 20];
    [UIView animateWithDuration:0.25 animations:^{
        [[self view] layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonClick:(id)sender
{
    [[self requestField] resignFirstResponder];
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:[[self requestField] text]]];
    [request send];
    [[self responseField] setText:@"Loading, please wait..."];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    [[self responseField] setText:[NSString stringWithFormat:@"%@", [response headers]]];
}

-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_bottomSpace release];
    [_responseField release];
    [_requestField release];
    [super dealloc];
}
@end
