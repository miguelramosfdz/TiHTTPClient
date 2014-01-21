//
//  TiTestsViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/17/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiTestsViewController.h"
#import "TiBaseViewController.h"
#import "TiWebColor.h"
#import "TiRequest.h"

static NSArray* TestsArray = nil;

@interface TiTestsViewController ()

@end

@implementation TiTestsViewController

+(NSArray*)testArray {
    if(TestsArray == nil) {
        TestsArray = @[
                       @{
                           @"header" : @"GET requests",
                           @"tests" : @[
                                   @{@"title": @"Simple get", @"viewController": @"SimpleGet"},
                                   @{@"title": @"Progress", @"viewController": @"GetProgress"},
                                   @{@"title": @"Response Headers", @"viewController": @"GetHeaders"}
                                   ]
                           }
                       ,
                       @{
                           @"header" : @"POST requests",
                           @"tests" : @[
                                   @{@"title": @"Post form", @"viewController": @"PostForm", @"method":@"POST"},
                                   @{@"title": @"Post image", @"viewController": @"PostImage", @"method":@"POST"},
                                   @{@"title": @"Post form with image", @"viewController": @"PostImageForm", @"method":@"POST"},
                                   @{@"title": @"Post JSON string", @"viewController": @"PostJsonString", @"method":@"POST"}
                                   ]
                           
                           },
                       @{
                           @"header" : @"PUT requests",
                           @"tests" : @[
                                   @{@"title": @"Put form", @"viewController": @"PostForm", @"method":@"PUT"},
                                   @{@"title": @"Put image", @"viewController": @"PostImage", @"method":@"PUT"},
                                   @{@"title": @"Put form with image", @"viewController": @"PostImageForm", @"method":@"PUT"},
                                   @{@"title": @"Put JSON string", @"viewController": @"PostJsonString", @"method":@"PUT"}
                                   ]
                           
                           },
                       @{
                           @"header" : @"Auth",
                           @"tests" : @[
                                   @{@"title": @"Auth Basic", @"viewController": @"Auth", @"method":@"GET", @"type": [NSNumber numberWithInt:TiRequestAuthBasic]},
                                   @{@"title": @"Auth Challange", @"viewController": @"Auth", @"method":@"GET", @"type": [NSNumber numberWithInt:TiRequestAuthChallange]},
                                   @{@"title": @"Auth Digest", @"viewController": @"Auth", @"method":@"GET", @"type":[NSNumber numberWithInt:TiRequestAuthDigest]}
                                   ]
                           
                           },
                       @{
                           @"header" : @"Synchronous requests",
                           @"tests" : @[
                                   @{@"title": @"Get Synchronous", @"viewController": @"Synchronous", @"method":@"GET"},
                                   @{@"title": @"Post Synchronous", @"viewController": @"Synchronous", @"method":@"POST"},
                                   @{@"title": @"Put Synchronous", @"viewController": @"Synchronous", @"method":@"PUT"},
                                   @{@"title": @"Delete Synchronous", @"viewController": @"Synchronous", @"method":@"DELETE"},
                                   @{@"title": @"Patch Synchronous", @"viewController": @"Synchronous", @"method":@"PATCH"}
                                   ]
                           },

                       @{
                           @"header" : @"Cookies",
                           @"tests" : @[
                                   @{@"title": @"Get Cookies", @"viewController": @"CookiesGet"},
                                   @{@"title": @"Set Cookies", @"viewController": @"CookiesSet"}
                                   ]
                           
                           }
                       ];
        [TestsArray retain];
    }
    return TestsArray;
}

-(void)dealloc
{
    RELEASE_TO_NIL(TestsArray);
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        TestsArray = [TiTestsViewController testArray];
    }
    return self;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Tests"];
    [[self view] setBackgroundColor:[TiWebColor webColorNamed:@"#CCC"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSDictionary*)currentCellInfo:(NSIndexPath*)indexPath
{
    NSArray *cells = [[TestsArray objectAtIndex:[indexPath section]] objectForKey:@"tests"];
    return [cells objectAtIndex:[indexPath row]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [TestsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[TestsArray objectAtIndex:section] objectForKey:@"tests"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDictionary *rowData = [self currentCellInfo:indexPath];
    [[cell textLabel] setText: [rowData valueForKey:@"title"]];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[TestsArray objectAtIndex:section] objectForKey:@"header"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = [self currentCellInfo:indexPath];
    NSString *viewControllerName = [NSString stringWithFormat:@"Ti%@ViewController",
                                    [rowData valueForKey:@"viewController"]];
    
    Class viewControllerClass = NSClassFromString(viewControllerName);
    
    if(viewControllerClass != nil) {
        TiBaseViewController *viewController = [[viewControllerClass alloc] init];
        if([rowData valueForKey:@"method"] != nil) {
            [viewController setMethod:[rowData valueForKey:@"method"]];
        }
        if([rowData valueForKey:@"type"] != nil) {
            [viewController setType:[[rowData valueForKey:@"type"] integerValue]];
        }
        [[self navigationController] pushViewController:viewController animated:YES];
        [viewController release];
    } else {
        PELog(@"%@ does not exist", viewControllerName);
    }
    
}
@end
