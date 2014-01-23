//
//  TiPostImageViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiHTTPRequest.h"

@interface TiPostImageViewController : TiBaseViewController<TiHTTPRequestDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *myImage;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@end
