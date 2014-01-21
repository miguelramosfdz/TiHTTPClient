//
//  TiRequest.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiRequest.h"
#import "TiResponse.h"
#import "TiForm.h"
#import "TiHelper.h"

@implementation TiRequest
@synthesize url = _url;
@synthesize method = _method;
@synthesize response = _response;
@synthesize filePath = _filePath;
@synthesize requestPassword = _requestPassword;
@synthesize requestUsername = _requestUsername;

- (void)dealloc
{
    RELEASE_TO_NIL(_request)
    RELEASE_TO_NIL(_response)
    RELEASE_TO_NIL(_url)
    RELEASE_TO_NIL(_method)
    RELEASE_TO_NIL(_filePath)
    RELEASE_TO_NIL(_requestUsername)
    RELEASE_TO_NIL(_requestPassword)
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    [self setSendDefaultCookies:YES];
    _request = [[NSMutableURLRequest alloc] init];
    [_request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    _response = [[TiResponse alloc] init];
    [_response setReadyState: TiResponseStateUnsent];
}

-(void)send
{
    [self send:nil async:YES];
}

-(void)send:(TiForm*)postForm
{
    [self send:postForm async:YES];
}

-(void)send:(TiForm*)postForm async:(BOOL)asynchronous
{
    if(postForm != nil) {
        NSData *data = [postForm requestData];
        [_request setHTTPBody:data];
        PELog(@"Data: %@", [NSString stringWithUTF8String: [data bytes]]);
        NSDictionary *headers = [postForm requestHeaders];
        for (NSString* key in headers)
        {
            [_request setValue:[headers valueForKey:key] forHTTPHeaderField:key];
            PELog(@"Header: %@: %@", key, [headers valueForKey:key]);
        }
    }
    PELog(@"URL: %@", [self url]);
    [_request setURL: [self url]];

    if([self timeout] > 0) {
        [_request setTimeoutInterval:[self timeout]];
    }
    if([self method] != nil) {
        [_request setHTTPMethod: [self method]];
        PELog(@"Method: %@", [self method]);
    }
    [_request setHTTPShouldHandleCookies:[self sendDefaultCookies]];
    
    if(asynchronous) {
        NSURLConnection *c = [[[NSURLConnection alloc] initWithRequest: _request delegate:self] autorelease];
        [_response setRequest:_request];
        [_response setReadyState:TiResponseStateOpened];
        if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
            [_delegate tiRequest:self onReadyStateChage:_response];
        }
        [c start];
    } else {
        NSURLResponse *response;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        [_response appenData:responseData];
        [_response setResponse:response];
        [_response setError:error];
        [_response setRequest:_request];
        [_response setReadyState:TiResponseStateDone];
        [_response setConnected:NO];
    }
    
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]) {
        PELog(@"%s %@", __PRETTY_FUNCTION__, @"previousFailureCount");
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    } else {
        PELog(@"%s", __PRETTY_FUNCTION__);
        [[challenge sender] useCredential:
         [NSURLCredential credentialWithUser:[self requestUsername]
                                    password:[self requestPassword]
                                 persistence:NSURLCredentialPersistenceForSession]
               forAuthenticationChallenge:challenge];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    PELog(@"%s", __PRETTY_FUNCTION__);
}

-(void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    PELog(@"%s", __PRETTY_FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    PELog(@"1 %s %@", __PRETTY_FUNCTION__, [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]]);

    [_response setReadyState:TiResponseStateHeaders];
    [_response setConnected:YES];
    [_response setResponse:response];
    _expectedResponseLength = [response expectedContentLength];
    
    if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
        [_delegate tiRequest:self onReadyStateChage:_response];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    PELog(@"2 %s", __PRETTY_FUNCTION__);

    if([_response readyState] != TiResponseStateLoading) {
        [_response setReadyState:TiResponseStateLoading];
        if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
            [_delegate tiRequest:self onReadyStateChage:_response];
        }
    }
    [_response appenData:data];
    [_response setProgress: (float)[[_response responseData] length] / (float)_expectedResponseLength];
    if([_delegate respondsToSelector:@selector(tiRequest:onDataStream:)]) {
        [_delegate tiRequest:self onDataStream:_response];
    }
    
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if([_response readyState] != TiResponseStateLoading) {
        [_response setReadyState:TiResponseStateLoading];
        if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
            [_delegate tiRequest:self onReadyStateChage:_response];
        }
    }
    [_response setProgress: (float)totalBytesExpectedToWrite / (float)totalBytesWritten];
    if([_delegate respondsToSelector:@selector(tiRequest:onDataStream:)]) {
        [_delegate tiRequest:self onDataStream:_response];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    PELog(@"3 %s", __PRETTY_FUNCTION__);
    [_response setReadyState:TiResponseStateDone];
    [_response setConnected:NO];
    if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
        [_delegate tiRequest:self onReadyStateChage:_response];
    }
    if([_delegate respondsToSelector:@selector(tiRequest:onLoad:)]) {
        [_delegate tiRequest:self onLoad:_response];
    }
    if([self filePath] != nil) {
        NSError *error = nil;
        [[_response responseData] writeToFile:[self filePath] options:NSDataWritingAtomic error:&error];
        if(error != nil) {
            PELog(@"Could not save to file %@ - Error is %@", [self filePath], [error localizedDescription]);
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    PELog(@"%s", __PRETTY_FUNCTION__);
    [_response setReadyState:TiResponseStateDone];
    if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
        [_delegate tiRequest:self onReadyStateChage:_response];
    }
    [_response setConnected:NO];
    [_response setError:error];
    if([_delegate respondsToSelector:@selector(tiRequest:onError:)]) {
        [_delegate tiRequest:self onError:_response];
    }
}


@end
