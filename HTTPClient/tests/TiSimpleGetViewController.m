//
//  TiSimpleGetViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiSimpleGetViewController.h"
#import "TiResponse.h"

@interface TiSimpleGetViewController ()

@end

@implementation TiSimpleGetViewController

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
    [self setTitle:@"Simple GET request"];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonClick:(id)sender
{
    PELog(@"%s", __PRETTY_FUNCTION__);
    [[self addressField] resignFirstResponder];
    [[self responseField] setText:@"Loading, please wait..."];
    
    TiRequest *request = [[[TiRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:[[self addressField] text]]];
    [request send];
    
}

-(void)tiRequest:(TiRequest *)request onDataStream:(TiResponse *)response
{
    PELog(@"%s", __PRETTY_FUNCTION__);
    [[self responseField] setText:
     [NSString stringWithFormat:@"Loading, please wait...\n%f%%", [response progress]]
     ];
}

-(void)tiRequest:(TiRequest *)request onLoad:(TiResponse *)response
{
    PELog(@"%s", __PRETTY_FUNCTION__);
    [[self responseField] setText: [response responseString]];
}

-(void)tiRequest:(TiRequest *)request onError:(TiResponse *)response
{
    [[self responseField] setText:[[response error] localizedDescription]];
    Alert(@"Error", [[response error] localizedDescription]);
}

-(void)tiRequest:(TiRequest *)request onReadyStateChage:(TiResponse *)response
{
    PELog(@"Read State: %i", [response readyState]);
}
- (void)dealloc {
    [_addressField release];
    [_responseField release];
    [super dealloc];
}
@end
