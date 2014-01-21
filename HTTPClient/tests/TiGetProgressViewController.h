//
//  TiGetProgrssViewController.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiBaseViewController.h"
#import "TiRequest.h"

@interface TiGetProgressViewController : TiBaseViewController<TiRequestDelegate>
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;

@end
