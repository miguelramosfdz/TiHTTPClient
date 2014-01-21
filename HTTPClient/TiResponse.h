//
//  TiResponse.h
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	TiResponseStateUnsent = 0,
	TiResponseStateOpened = 1,
    TiResponseStateHeaders = 2,
    TiResponseStateLoading = 3,
    TiResponseStateDone = 4
} TiResponseState;

@interface TiResponse : NSObject
{
    NSMutableData *_data;
}
@property(nonatomic, readonly) NSURL *url;
@property(nonatomic, readonly) NSInteger status;
@property(nonatomic, readonly) NSDictionary *headers;
@property(nonatomic, readonly) NSString *connectionType;
@property(nonatomic, readonly) NSString *location;
@property(nonatomic) float progress;
@property(nonatomic, retain) NSError *error;


@property(nonatomic, readonly) NSData* responseData;
@property(nonatomic, readonly) NSString*responseString;
@property(nonatomic, readonly) NSDictionary*responseDictionary;
@property(nonatomic, readonly) NSArray* responseArray;

@property(nonatomic) BOOL connected;
@property(nonatomic) TiResponseState readyState;


-(void)appenData:(NSData*)data;
-(void)setResponse:(NSURLResponse*) response;
-(void)setRequest:(NSURLRequest*) request;
@end
