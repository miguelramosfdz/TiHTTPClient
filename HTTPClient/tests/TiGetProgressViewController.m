//
//  TiGetProgrssViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiGetProgressViewController.h"
#import "TiResponse.h"
@interface TiGetProgressViewController ()

@end

@implementation TiGetProgressViewController

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
    [self setTitle:@"Download progress"];
    [[self progressBar] setProgress:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonClick:(id)sender
{
    [[self progressBar] setProgress:0];
    TiRequest *request = [[[TiRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:@"http://cdn.petkaria.com/pictures/z.about.com/d/cameras/1/0/u/1/bigcat.JPG"]];
    [request send];
}

-(void)tiRequest:(TiRequest *)request onLoad:(TiResponse *)response
{
    Alert(@"Success!", @"Image downloaded!");
}
-(void)tiRequest:(TiRequest *)request onDataStream:(TiResponse *)response
{
    [[self progressBar]setProgress:[response progress]];
}
-(void)tiRequest:(TiRequest *)request onError:(TiResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_progressBar release];
    [super dealloc];
}
@end
