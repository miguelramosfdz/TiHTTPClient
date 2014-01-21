//
//  TiGetSynchronousViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/20/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"

@interface TiSynchronousViewController : TiBaseViewController

@property (retain, nonatomic) IBOutlet UITextField *requestField;
@property (retain, nonatomic) IBOutlet UITextView *responseField;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end
