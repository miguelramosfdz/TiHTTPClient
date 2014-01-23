//
//  TiGetGzipViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/21/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiGetGzipViewController.h"
#import "TiHTTPResponse.h"
#import "TiHTTPPostForm.h"

@interface TiGetGzipViewController ()

@end

@implementation TiGetGzipViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant:top + 20];
}

- (IBAction)onButtonClick:(id)sender
{
    [[self requestField] resignFirstResponder];
    [[self responseField] setText:@"Loading, please wait..."];
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];

    if([[self toggle] isOn]) {
        TiHTTPPostForm *form = [[[TiHTTPPostForm alloc] init] autorelease];
        [form addHeaderKey:@"Accept-Encoding" andHeaderValue:@"gzip, deflate"];
        [request setPostForm:form];
    }
    [request setRedirects:NO];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:[[self requestField] text]]];
    [request send];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    [[self responseField] setText:[NSString stringWithFormat:@"%@",[response headers]]];
}

-(void)tiRequest:(TiHTTPRequest *)request onDataStream:(TiHTTPResponse *)response
{
    [[self responseField] setText:[response responseString]];
}

-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_requestField release];
    [_toggle release];
    [_responseField release];
    [_bottomSpace release];
    [super dealloc];
}
@end
