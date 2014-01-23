//
//  TiGetSynchronousViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/20/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiSynchronousViewController.h"
#import "TiHTTPPostForm.h"
#import "TiHTTPRequest.h"
#import "TiHTTPResponse.h"

@interface TiSynchronousViewController ()

@end

@implementation TiSynchronousViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setMethod:@"GET"];
    }
    return self;
}
-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant:20 + top];
    [UIView animateWithDuration:0.25 animations:^{
        [[self view] layoutIfNeeded];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"%@ Request", [self method]]];
    [[self requestField] setText:[NSString stringWithFormat:@"http://httpbin.org/%@", [[self method] lowercaseString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_requestField release];
    [_responseField release];
    [_bottomSpace release];
    [super dealloc];
}

- (IBAction)onButtonClick:(id)sender
{
    [[self requestField] resignFirstResponder];
    [[self responseField] setText:@"Loading, please wait..."];
    
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:[[self requestField] text]]];
    [request setSynchronous:YES];
    [request send];
    
    TiHTTPResponse *response = [request response];
    [[self responseField] setText:[response responseString]];
    
    PELog(@"[SYNC] error: %@",[[response error] localizedDescription]);
    PELog(@"[SYNC] url: %@",[response url]);
    PELog(@"[SYNC] status: %i",[response status]);
    PELog(@"[SYNC] headers: %@",[response headers]);
    PELog(@"[SYNC] connectionType: %@",[response connectionType]);
    PELog(@"[SYNC] location: %@",[response location]);
}
@end
