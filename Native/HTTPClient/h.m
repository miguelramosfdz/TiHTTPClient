//
//  h.c
//  HTTPClient
//
//  Created by Pedro Enrique on 1/17/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#include "h.h"
#define PeDEBUG   

void TiLogMessage(NSString* str, ...)
{
#ifdef PeDEBUG
    va_list args;
    va_start(args, str);
    
    NSString* message = [[NSString alloc] initWithFormat:str arguments:args];
    const char* s = [message UTF8String];
    fprintf(stderr,"[INFO] %s\n", s);
    fflush(stderr);
    [message release];
#endif
}

void Alert(NSString*title, NSString* message)
{
    [[[[UIAlertView alloc] initWithTitle: title
                                 message: message
                                delegate: nil
                       cancelButtonTitle: @"ok"
                       otherButtonTitles: nil
       ] autorelease] show];
}