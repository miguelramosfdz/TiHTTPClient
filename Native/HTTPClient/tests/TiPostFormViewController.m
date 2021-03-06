//
//  TiPostFormViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiPostFormViewController.h"
#import "TiHTTPPostForm.h"
#import "TiHTTPResponse.h"

@interface TiPostFormViewController ()

@end

@implementation TiPostFormViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setMethod:@"POST"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Post Form request"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_firstNameField release];
    [_lastNameField release];
    [_emailField release];
    [_bottomSpace release];
    [_scrollView release];
    [super dealloc];
}

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant: top + 20];
}

- (IBAction)onButtonClick:(id)sender
{
    [[self firstNameField] resignFirstResponder];
    [[self lastNameField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
    
    TiHTTPPostForm *postForm = [[[TiHTTPPostForm alloc] init] autorelease];
    
    if([[[self firstNameField] text] length] > 0) {
        [postForm addFormKey:@"first_name" andValue:[[self firstNameField] text]];
    }
    if([[[self lastNameField] text] length] > 0) {
        [postForm addFormKey:@"last_name" andValue:[[self lastNameField] text]];
    }
    if([[[self emailField] text] length] > 0) {
        [postForm addFormKey:@"email_address" andValue:[[self emailField] text]];
    }
    
    [postForm addHeaderKey:@"Accept" andHeaderValue:@"application/json"];
    
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
    [request setUrl:[NSURL URLWithString:
                     [NSString stringWithFormat:@"http://httpbin.org/%@", [[self method] lowercaseString]]
                     ]];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setPostForm:postForm];
    [request send];
    
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    Alert(@"Success!", @"See log for details");
    PELog(@"%@", [response responseDictionary]);
}
-(void)tiRequest:(TiHTTPRequest *)request onDataStream:(TiHTTPResponse *)response
{
    
}
-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

@end
