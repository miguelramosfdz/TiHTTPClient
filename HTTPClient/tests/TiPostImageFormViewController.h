//
//  TiPostImageFormViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiHTTPRequest.h"

@interface TiPostImageFormViewController : TiBaseViewController<
UIImagePickerControllerDelegate,
TiHTTPRequestDelegate,
UITextFieldDelegate
>

@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UITextField *firstNameField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameField;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
