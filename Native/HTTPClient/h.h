//
//  h.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/17/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#ifndef HTTPClient_h_h
#define HTTPClient_h_h

#import <Foundation/Foundation.h>

#define RELEASE_TO_NIL(obj) \
{ \
if(obj != nil) [obj release]; \
obj = nil; \
}

void Alert(NSString*title, NSString* message);
void TiLogMessage(NSString* str, ...);
#define PELog(...) {\
TiLogMessage(__VA_ARGS__);\
}


#endif
