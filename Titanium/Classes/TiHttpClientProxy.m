/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiHttpClientProxy.h"
#import "TiHttpModule.h"
#import "TiHTTPResponse.h"
#import "TiHTTPPostForm.h"
#import "TiHTTPOperation.h"

#import "TiUtils.h"
#import "TiDOMDocumentProxy.h"
#import "TiBlob.h"

@implementation TiHttpClientProxy

- (void)dealloc
{
    RELEASE_TO_NIL(response);
    RELEASE_TO_NIL(httpRequest);
    [super dealloc];
}
-(TiHTTPRequest*)request
{
    if(httpRequest == nil) {
        httpRequest = [[TiHTTPRequest alloc] init];
        [httpRequest setDelegate:self];
    }
    return httpRequest;
}

-(void)open:(id)args
{
    ENSURE_ARRAY(args)
    
    [[self request] setMethod: [TiUtils stringValue:[args objectAtIndex:0]]];
    [[self request] setUrl:[NSURL URLWithString:[TiUtils stringValue:[args objectAtIndex:1]]]];
    
    if([args count] >= 3) {
        [self replaceValue:[args objectAtIndex:2] forKey:@"async" notification:NO];
    }
}

-(void)send:(id)args
{
    [self rememberSelf];
    
    if([self valueForUndefinedKey:@"autoRedirect"]) {
        [[self request] setRedirects:
         [TiUtils boolValue: [self valueForUndefinedKey:@"autoRedirect"] def:YES] ];
    }
    TiHTTPPostForm *form = nil;
    if(args != nil) {
        ENSURE_ARRAY(args)
        form = [[[TiHTTPPostForm alloc] init] autorelease];
        id arg = [args objectAtIndex:0];
        if([arg isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)arg;
            NSInteger dataIndex = 0;
            for(NSString *key in dict) {
                id value = [dict objectForKey:key];
                
                if([key isEqualToString:@"image"]) {
                    NSLog(@"%@", value);
                }
                if([value isKindOfClass:[NSString class]]) {
                    [form addFormKey:key andValue: (NSString*)value];
                }
                else if([value isKindOfClass:[TiBlob class]]) {
                    [form addFormData:[(TiBlob*)value data]
                             fileName:[NSString stringWithFormat:@"file%i", dataIndex++]
                            fieldName:key];
                }
                else if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil];
                    [form addFormKey:key
                            andValue:[NSString stringWithUTF8String:[jsonData bytes]]];
                }
            }
        } else if ([arg isKindOfClass:[TiBlob class]]) {
            TiBlob *blob = (TiBlob*)arg;
            [form addFormData:[blob data]];
        } else if([arg isKindOfClass:[NSString class]]) {
            [form setStringData:(NSString*)arg];
        }
    }
    
    if(form != nil) {
        [[self request] setPostForm:form];
    }
    
    BOOL async = YES;
    if([self valueForUndefinedKey:@"async"]) {
        async = [TiUtils boolValue:[self valueForUndefinedKey:@"async"]];
    }
    
    if(async) {
        [[self request] setTheQueue:[TiHttpModule operationQueue]];
        [[self request] send];
    } else {
        [[self request] setSynchronous:YES];
        [[self request] send];
        response = [[[self request] response] retain];
    }
}

-(void)tiRequest:(TiHTTPRequest *)request onDataStream:(TiHTTPResponse *)tiResponse
{
    if([self valueForKey:@"onsendstream"]) {
        NSDictionary *eventDict = @{@"progress": [NSNumber numberWithFloat: [tiResponse progress]]};
        [self fireCallback:@"onsendstream" withArg:eventDict withSource:self];
    }
}

-(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)tiResponse
{
    if([self valueForUndefinedKey:@"onerror"]) {
        [self replaceValue:[[tiResponse error] localizedDescription] forKey:@"error" notification:NO];
        [self fireCallback:@"onerror" withArg:nil withSource:self];
    }
    [self forgetSelf];
}

-(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)tiResponse
{
    response = [tiResponse retain];
    if([self valueForUndefinedKey:@"onload"]) {
        [self fireCallback:@"onload" withArg:nil withSource:self];
    }
    [self forgetSelf];
}

-(void)tiRequest:(TiHTTPRequest *)request onReadyStateChage:(TiHTTPResponse *)tiResponse
{
    if([self valueForUndefinedKey:@"onreadystatechange"]) {
        [self fireCallback:@"onreadystatechange" withArg:nil withSource:self];
    }
}


-(NSString*)responseText
{
    return [response responseString];
}
-(TiBlob*)responseData
{
    return [[[TiBlob alloc] initWithData:[response responseData] mimetype:@""] autorelease];
}
-(TiDOMDocumentProxy*)responseXML
{
    if ([self responseText] != nil && (![[self responseText] isEqual:(id)[NSNull null]])) {
        TiDOMDocumentProxy *responseXML = [[[TiDOMDocumentProxy alloc] _initWithPageContext:[self executionContext]] autorelease];
        [responseXML parseString:[self responseText] skipExceptions:YES];
        return responseXML;
    }
    return nil;
}
-(NSDictionary*)responseDictionary
{
    return [response responseDictionary];
}
-(NSArray*)responseArray
{
    return [response responseArray];
}

-(NSNumber*)readyState
{
    return NUMINT([response readyState]);
}

-(NSDictionary*)responseHeaders
{
    return [response headers];
}

-(NSString*)getResponseHeader:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString)
    return [[response headers] valueForKey:args];
}
@end
