//
//  TiRequest.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	TiRequestAuthNone = 0,
	TiRequestAuthBasic = 1,
	TiRequestAuthDigest = 2,
    TiRequestAuthChallange = 3
} TiRequestAuth;


@class TiResponse;
@class TiRequest;
@class TiForm;

@protocol TiRequestDelegate <NSObject>
@optional
-(void)tiRequest:(TiRequest*)request onLoad:(TiResponse*)response;
-(void)tiRequest:(TiRequest*)request onError:(TiResponse*)response;
-(void)tiRequest:(TiRequest *)request onDataStream:(TiResponse *)response;
-(void)tiRequest:(TiRequest *)request onReadyStateChage:(TiResponse *)response;

@end

@interface TiRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableURLRequest *_request;
    long long _expectedResponseLength;
}

@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) NSString *method;
@property(nonatomic, retain) NSString *filePath;
@property(nonatomic, retain) NSString *requestUsername;
@property(nonatomic, retain) NSString *requestPassword;
@property(nonatomic, readonly) TiResponse* response;
@property(nonatomic, assign) NSObject<TiRequestDelegate>* delegate;
@property(nonatomic) NSTimeInterval timeout;
@property(nonatomic) BOOL sendDefaultCookies;
@property(nonatomic) TiRequestAuth authType;


-(void)send:(TiForm*)postForm async:(BOOL)synchronous;
-(void)send:(TiForm*)postForm;
-(void)send;
@end
