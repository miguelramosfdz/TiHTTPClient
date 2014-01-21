//
//  TiPostImageViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/18/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiPostImageViewController.h"
#import "TiForm.h"
#import "TiResponse.h"

@interface TiPostImageViewController ()

@end

@implementation TiPostImageViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setMethod:@"POST"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Upload Image"];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init] autorelease];
    [tap addTarget:self action:@selector(onSelectImage:)];
    [tap setNumberOfTapsRequired:1];
    [[self myImage] addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSelectImage:(id)sender
{
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)uploadImage:(id)sender
{
    UIImage *image = [[self myImage] image];

    TiForm *form = [[[TiForm alloc] init] autorelease];
    [form addFormData: UIImageJPEGRepresentation(image, 0.7)
             fileName:@"image.jpeg"
            fieldName:@"image"];
    
    TiRequest *request = [[[TiRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setMethod:[self method]];
    [request setUrl:[NSURL URLWithString:
                     [NSString stringWithFormat:@"http://httpbin.org/%@", [[self method] lowercaseString]]
                     ]];
    [request send:form];
    [[self progressBar] setProgress:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [[self myImage] setImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)tiRequest:(TiRequest *)request onLoad:(TiResponse *)response
{
    Alert(@"OnLoad", @"See log for details");
    NSLog(@"%@", [response responseDictionary]);
}

-(void)tiRequest:(TiRequest *)request onDataStream:(TiResponse *)response
{
    [[self progressBar] setProgress:[response progress]];
}
-(void)tiRequest:(TiRequest *)request onError:(TiResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

- (void)dealloc {
    [_myImage release];
    [_progressBar release];
    [super dealloc];
}
@end
