//
//  TiRequest.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/16/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiHTTPRequest.h"
#import "TiHTTPResponse.h"
#import "TiHTTPPostForm.h"
#import "TiHTTPHelper.h"

@implementation TiHTTPRequest
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
    RELEASE_TO_NIL(_postForm)
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
    [self setRedirects:YES];
    _request = [[NSMutableURLRequest alloc] init];
    [_request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    _response = [[TiHTTPResponse alloc] init];
    [_response setReadyState: TiResponseStateUnsent];
}

-(void)send
{
    if([self postForm] != nil) {
        NSData *data = [[self postForm] requestData];
        [_request setHTTPBody:data];
        PELog(@"Data: %@", [NSString stringWithUTF8String: [data bytes]]);
        NSDictionary *headers = [[self postForm] requestHeaders];
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
    
    if([self synchronous]) {
        NSURLResponse *response;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error];
        [_response appenData:responseData];
        [_response setResponse:response];
        [_response setError:error];
        [_response setRequest:_request];
        [_response setReadyState:TiResponseStateDone];
        [_response setConnected:NO];
    } else {
        NSURLConnection *c = [[[NSURLConnection alloc] initWithRequest: _request delegate:self] autorelease];
        [_response setRequest:_request];
        [_response setReadyState:TiResponseStateOpened];
        if([_delegate respondsToSelector:@selector(tiRequest:onReadyStateChage:)]) {
            [_delegate tiRequest:self onReadyStateChage:_response];
        }
        [c start];
    }
    
}


-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([self requestPassword] == nil || [self requestUsername] == nil) return;
    
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

-(NSURLRequest*)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    PELog(@"Code %i Redirecting from: %@ to: %@",[(NSHTTPURLResponse*)response statusCode], [_request URL] ,[request URL]);
    [_response setConnected:YES];
    [_response setResponse: response];
    if(![self redirects] && [_response status] != 0)
    {
        [_response setRequest: request];
        return nil;
    }
    
    //http://tewha.net/2012/05/handling-302303-redirects/
    if (response) {
        NSMutableURLRequest *r = [[_request mutableCopy] autorelease];
        [r setURL: [request URL]];
        RELEASE_TO_NIL(_request);
        _request = [r retain];
        return r;
    } else {
        return request;
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    PELog(@"%s", __PRETTY_FUNCTION__);
    [_response setReadyState:TiResponseStateHeaders];
    [_response setConnected:YES];
    [_response setResponse: response];
    if([_response status] == 0) {
        [self connection:connection
        didFailWithError:[NSError errorWithDomain: [_response location]
                                             code: [_response status]
                                         userInfo: @{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse*)response statusCode]]}
                          ]];
        return;
    }
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
