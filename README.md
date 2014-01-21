Content of the source is inside [HTTPClient/TiHTTPClient](https://github.com/pec1985/TiHTTPClient/tree/master/HTTPClient/TiHTTPClient)  
Tests are inside [HTTPClient/tests](https://github.com/pec1985/TiHTTPClient/tree/master/HTTPClient/tests)  
Each test is a UIViewController subclass of TiBaseViewController. The UI is in each corresponding xib file.


### Components
**TiHTTPRequest** - Responsible for the http request  
**NSObject\<TiHTTPRequestDelegate\>** - Responsible for the TiHTTPRequest callbacks  
**TiHTTPPostForm** - Used to build a post form  
**TiHTTPResponse** - Holds all the response information from the request  
**TiHTTPHelper** - Helper class with some handy functions

### Examples:
#### GET Request:

    -(void)sendRequest
    {
        TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
        [request setDelegate:self];
        [request setMethod: @"GET"];
        [request setUrl:[NSURL URLWithString: @"http://google.com/"]];
        [request send];
    }

    -(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
    {
        NSString* response = [response responseString];
    }
    
    -(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
    {
        NSString* errorMessage = [[response error] localizedDescription];
    }

#### POST Request:

    -(void)sendRequest
    {
        TiHTTPPostForm *form = [[[TiHTTPPostForm alloc] init] autorelease];
        [form addFormKey:@"first_name" andValue: @"John"];
        [form addFormKey:@"last_name" andValue: @"Smith"];
        [form addFormData: UIImageJPEGRepresentation([[self myImageView] image], 0.7)
                 fileName:@"image.jpeg"
                fieldName:@"photo"];
    
        TiHTTPRequest *request = [[[TiHTTPRequest alloc] init] autorelease];
        [request setDelegate:self];
        [request setMethod: @"POST"];
        [request setPostForm:form];
        [request setUrl:[NSURL URLWithString: @"http://some_server.com/api/post"]];
        [request send];
    }

    -(void)tiRequest:(TiHTTPRequest *)request onLoad:(TiHTTPResponse *)response
    {
        NSString* response = [response responseString];
    }
    
    -(void)tiRequest:(TiHTTPRequest *)request onError:(TiHTTPResponse *)response
    {
        NSString* errorMessage = [[response error] localizedDescription];
    }
    
