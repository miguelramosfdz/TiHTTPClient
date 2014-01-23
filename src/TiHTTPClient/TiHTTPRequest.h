//
//  TiRequest.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PELog
#define PELog(...) {\
/*NSLog(__VA_ARGS__);*/\
}
#endif
#ifndef RELEASE_TO_NIL
#define RELEASE_TO_NIL(x) { if (x!=nil) { [x release]; x = nil; } }
#endif

typedef enum {
	TiRequestAuthNone = 0,
	TiRequestAuthBasic = 1,
	TiRequestAuthDigest = 2,
    TiRequestAuthChallange = 3
} TiRequestAuth;


@class TiHTTPResponse;
@class TiHTTPRequest;
@class TiHTTPPostForm;
@class TiHTTPOperation;

@protocol TiHTTPRequestDelegate <NSObject>
@optional
-(void)tiRequest:(TiHTTPRequest*)request onLoad:(TiHTTPResponse*)response;
-(void)tiRequest:(TiHTTPRequest*)request onError:(TiHTTPResponse*)response;
-(void)tiRequest:(TiHTTPRequest *)request onDataStream:(TiHTTPResponse *)response;
-(void)tiRequest:(TiHTTPRequest *)request onReadyStateChage:(TiHTTPResponse *)response;

@end

@interface TiHTTPRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    long long _expectedResponseLength;
}

@property(nonatomic, readonly) NSMutableURLRequest *request;
@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) NSString *method;
@property(nonatomic, retain) NSString *filePath;
@property(nonatomic, retain) NSString *requestUsername;
@property(nonatomic, retain) NSString *requestPassword;
@property(nonatomic, retain) TiHTTPPostForm *postForm;
@property(nonatomic, retain) TiHTTPOperation* operation;
@property(nonatomic, readonly) TiHTTPResponse* response;
@property(nonatomic, assign) NSObject<TiHTTPRequestDelegate>* delegate;
@property(nonatomic) NSTimeInterval timeout;
@property(nonatomic) BOOL sendDefaultCookies;
@property(nonatomic) BOOL redirects;
@property(nonatomic) BOOL synchronous;
@property(nonatomic) TiRequestAuth authType;
@property(nonatomic, retain) NSOperationQueue *theQueue;

-(void)send;
@end
