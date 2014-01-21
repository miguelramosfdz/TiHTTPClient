//
//  TiSimpleGetViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiHTTPRequest.h"

@interface TiSimpleGetViewController : TiBaseViewController<TiHTTPRequestDelegate>

@property (retain, nonatomic) IBOutlet UITextField *addressField;
@property (retain, nonatomic) IBOutlet UITextView *responseField;
@end
