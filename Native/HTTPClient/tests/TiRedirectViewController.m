//
//  TiRedirectViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/21/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiRedirectViewController.h"
#import "TiHTTPResponse.h"

@interface TiRedirectViewController ()

@end

@implementation TiRedirectViewController

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant: top + 20];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Redirect Test"];
    [[self requestField] setText:@"http://httpbin.org/redirect/6"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonClick:(id)sender
{
    [[self requestField] resignFirstResponder];
    [[self responseField] setText:@"Loading, please wait..."];
    
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setMethod:@"GET"];
    [request setRedirects:[[self toggle] isOn]];
    [request setUrl:[NSURL URLWithString:[[self requestField] text]]];
    [request send];
}
- (IBAction)onToggle:(id)sender
{
    [[self requestField] resignFirstResponder];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    [[self responseField] setText:[response responseString]];
    PELog(@"Location: %@", [response location]);
    PELog(@"Status: %i", [response status]);
    PELog(@"Headers: %@", [response headers]);

}
-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
    PELog(@"%@", [response headers]);
}
-(void)tiRequest:(TiHTTPRequest *)request onReadyStateChage:(TiHTTPResponse *)response
{
    PELog(@"Progress: %f", [response progress]);
}

- (void)dealloc {
    [_requestField release];
    [_responseField release];
    [_bottomSpace release];
    [_toggle release];
    [super dealloc];
}
@end
