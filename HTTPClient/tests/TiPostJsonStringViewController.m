//
//  TiPostJsonStringViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiPostJsonStringViewController.h"
#import "TiHTTPResponse.h"
#import "TiHTTPPostForm.h"

@interface TiPostJsonStringViewController ()

@end

@implementation TiPostJsonStringViewController

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
    [self setTitle:@"Post JSON string"];
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
    NSDictionary *dict = @{ [[self key1Field] text]: [[self value1Field] text],
                            [[self key2Field] text]: [[self value2Field] text],
                            [[self key3Field] text]: [[self value3Field] text]
                            };
    TiHTTPPostForm *form = [[[TiHTTPPostForm alloc] init] autorelease];
    [form setJSONData:dict];
    
    TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setUrl:[NSURL URLWithString:
                     [NSString stringWithFormat:@"http://httpbin.org/%@", [[self method] lowercaseString]]
                     ]];
    [request setMethod:[self method]];
    [request setPostForm:form];
    [request send];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
{
    Alert(@"Success!", @"See log for response");
    NSLog(@"%@", [response responseDictionary]);
}
-(void)tiRequest:(TiHTTPRequest *)request onDataStream:(TiHTTPResponse *)response
{
    
}
-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_key1Field release];
    [_key2Field release];
    [_key3Field release];
    [_value1Field release];
    [_value2Field release];
    [_value3Field release];
    [_bottomSpace release];
    [super dealloc];
}
@end
