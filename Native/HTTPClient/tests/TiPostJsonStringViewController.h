//
//  TiPostJsonStringViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiHTTPRequest.h"

@interface TiPostJsonStringViewController : TiBaseViewController<TiHTTPRequestDelegate>

@property (retain, nonatomic) IBOutlet UITextField *key1Field;
@property (retain, nonatomic) IBOutlet UITextField *key2Field;
@property (retain, nonatomic) IBOutlet UITextField *key3Field;
@property (retain, nonatomic) IBOutlet UITextField *value1Field;
@property (retain, nonatomic) IBOutlet UITextField *value2Field;
@property (retain, nonatomic) IBOutlet UITextField *value3Field;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@end
