//
//  TiResponse.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiHTTPResponse.h"

@implementation TiHTTPResponse

@synthesize url = _url;
@synthesize status = _status;
@synthesize headers = _headers;
@synthesize responseArray = _responseArray;
@synthesize responseData = _responseData;
@synthesize responseDictionary = _responseDictionary;
@synthesize responseString = _responseString;
@synthesize error = _error;

- (void)dealloc
{
    RELEASE_TO_NIL(_data);
    RELEASE_TO_NIL(_location);
    RELEASE_TO_NIL(_connectionType);
    RELEASE_TO_NIL(_headers);
    RELEASE_TO_NIL(_error);
    
    [super dealloc];
}
-(void)setResponse:(NSURLResponse*) response
{
    _url = [response URL];
    if([response isKindOfClass:[NSHTTPURLResponse class]]) {
        _status = [(NSHTTPURLResponse*)response statusCode];
        _headers = [[(NSHTTPURLResponse*)response allHeaderFields] retain];
    }
}
-(void)setRequest:(NSURLRequest*) request
{
    RELEASE_TO_NIL(_location);
    RELEASE_TO_NIL(_connectionType);
    _connectionType = [[request HTTPMethod] retain];
    _location = [[[request URL] absoluteString] retain];
}

-(void)appenData:(NSData *)data
{
    if(_data == nil) {
        _data = [[NSMutableData alloc] init];
    }
    [_data appendData:data];
}

-(NSData *)responseData
{
    if(_data == nil) {
        return nil;
    }
    return [[_data copy] autorelease];
}

-(id)jsonResponse
{
    if([self responseData] == nil) return nil;
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData: [self responseData]
                                              options: NSJSONReadingAllowFragments
                                                error: &error];
    if(error != nil) {
        PELog(@"%s - %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        return nil;
    }
    return json;
}

-(NSString*)responseString
{
    if([self error] != nil) {
        PELog(@"%s", __PRETTY_FUNCTION__);
        return [[self error] localizedDescription];
    }
    if([self responseData] == nil) return nil;
    return [NSString stringWithUTF8String: [[self responseData] bytes]];
}

-(NSDictionary*)responseDictionary
{
    id json = [self jsonResponse];
    if([json isKindOfClass:[NSDictionary class]]) {
        PELog(@"%s", __PRETTY_FUNCTION__);
        return (NSDictionary*)json;
    }
    PELog(@"%s - JSON is %@", __PRETTY_FUNCTION__, [[json superclass] description]);
    return nil;
}
-(NSArray*)responseArray
{
    id json = [self jsonResponse];
    if([json isKindOfClass:[NSArray class]]) {
        return (NSArray*)json;
    }
    PELog(@"%s - JSON is %@", __PRETTY_FUNCTION__, [[json superclass] description]);
    return nil;
}

@end
