//
//  TiAuthViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/20/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiAuthViewController.h"
#import "TiHTTPResponse.h"

@interface TiAuthViewController ()

@end

@implementation TiAuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *type;
    NSString *api;
    switch ([self type]) {
        case TiRequestAuthDigest:
            type = @"Auth Digest";
            api = @"digest-auth/auth";
            break;
        case TiRequestAuthChallange:
            type = @"Auth Challange";
            api = @"hidden-basic-auth";
            break;
        case TiRequestAuthBasic:
            type = @"Auth Basic";
            api = @"basic-auth";
            break;
        default:
            type = @"Auth None";
            api = @"";
            break;
    }
    
    [[self requestField] setText:[NSString stringWithFormat:@"http://httpbin.org/%@/user/password", api]];
    [self setTitle:[NSString stringWithFormat:@"%@ Request", type]];
}

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant: top + 20];
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
    [request setRequestUsername:@"user"];
    [request setRequestPassword:@"password"];

    // does nothing at this point.
    [request setAuthType:[self type]];
    
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString: [[self requestField] text]]];
    [request send];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    Alert(@"Success", @"See log for details");
    [[self responseField] setText:[response responseString]];
}

-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_bottomSpace release];
    [_requestField release];
    [_responseField release];
    [super dealloc];
}
@end
