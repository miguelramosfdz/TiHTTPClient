//
//  TiHTTPOperation.m
//  Titanium
//
//  Created by Pedro Enrique on 1/22/14.
//
//

#import "TiHTTPOperation.h"

@implementation TiHTTPOperation

- (void)dealloc
{
    RELEASE_TO_NIL(_connection);
    [super dealloc];
}

- (id)initWithConnection:(NSURLConnection *)connection
{
    self = [super init];
    if (self) {
        _connection = [connection retain];

    }
    [self willChangeValueForKey: @"isReady"];
    _ready = YES;
    [self didChangeValueForKey: @"isReady"];

    return self;
}

- (void)start
{
    [self willChangeValueForKey: @"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey: @"isExecuting"];
    [[self connection] start];
    
    // Keep running the run loop until all asynchronous operations are completed
    while (![self isFinished]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

}

- (void)cancel
{
    if([self connection] != nil){
        [[self connection] cancel];
    }
    [self willChangeValueForKey: @"isCancelled"];
    _cancelled = YES;
    [self didChangeValueForKey: @"isCancelled"];
    [super cancel];

}

-(void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey: @"isFinished"];
    _finished = finished;
    [self didChangeValueForKey: @"isFinished"];

}
-(BOOL)isReady
{
    return _ready;
}
- (BOOL)isCancelled
{
    return _cancelled;
}
- (BOOL)isExecuting
{
    return _executing;
}
- (BOOL)isFinished
{
    return _finished;
}
-(BOOL)isConcurrent
{
    return NO;
}

@end
