//
//  TiRedirectViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/21/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiHTTPRequest.h"

@interface TiRedirectViewController : TiBaseViewController<TiHTTPRequestDelegate>

@property (retain, nonatomic) IBOutlet UITextField *requestField;
@property (retain, nonatomic) IBOutlet UITextView *responseField;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (retain, nonatomic) IBOutlet UISwitch *toggle;

@end
