/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiHTTPRequest.h"

@class TiHTTPResponse;
@class TiDOMDocumentProxy;
@class TiBlob;

@interface TiHttpClientProxy : TiProxy<TiHTTPRequestDelegate>
{
    TiHTTPRequest *httpRequest;
    TiHTTPResponse* response;
}


@property(nonatomic, readonly)NSString* responseText;
@property(nonatomic, readonly)TiBlob* responseData;
@property(nonatomic, readonly)TiDOMDocumentProxy* responseXML;
@property(nonatomic, readonly)NSDictionary* responseDictionary;
@property(nonatomic, readonly)NSArray* responseArray;

@property(nonatomic, readonly)NSNumber* readyState;
@property(nonatomic, readonly)NSDictionary* responseHeaders;


@end
