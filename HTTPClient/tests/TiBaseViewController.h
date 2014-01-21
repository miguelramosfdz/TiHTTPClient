//
//  TiBaseViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiHTTPRequest.h"
@interface TiBaseViewController : UIViewController<UINavigationControllerDelegate>

@property(nonatomic, retain) NSString* method;

// for Auth tests
@property(nonatomic) TiRequestAuth type;

-(void)onKeyboard:(CGFloat)top;

@end
