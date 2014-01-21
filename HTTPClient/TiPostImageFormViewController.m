//
//  TiPostImageFormViewController.m
//  HTTPClient
//
//  Created by Pedro Enrique on 1/19/14.
//  Copyright (c) 2014 Pedro Enrique. All rights reserved.
//

#import "TiPostImageFormViewController.h"
#import "TiResponse.h"
#import "TiForm.h"

@interface TiPostImageFormViewController ()

@end

@implementation TiPostImageFormViewController

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
    [self setTitle:@"Form with image"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClick:)];
    [tap setNumberOfTapsRequired:1];
    [[self photoView] addGestureRecognizer: tap];
    [[self firstNameField] setDelegate:self];
    [[self lastNameField] setDelegate:self];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rc = [textField convertRect:[textField bounds] toView:[self scrollView]];
    CGPoint pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [[self scrollView] setContentOffset:pt animated:YES];
}

-(void)onKeyboard:(CGFloat)top
{
    [[self bottomSpace] setConstant:top + 20];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonClick:(id)sender
{
    [[self firstNameField] resignFirstResponder];
    [[self lastNameField] resignFirstResponder];
    
    TiForm *form = [[[TiForm alloc] init] autorelease];
    [form addHeaderKey:@"Accept" andHeaderValue:@"application.json"];
    [form addFormKey:@"first_name" andValue:[[self firstNameField] text]];
    [form addFormKey:@"last_name" andValue:[[self lastNameField] text]];
    [form addFormData: UIImageJPEGRepresentation([[self photoView] image], 0.7)
             fileName:@"image.jpeg"
            fieldName:@"photo"];
    
    TiRequest *request =[[[TiRequest alloc] init] autorelease];
    [request setDelegate:self];
    [request setUrl:[NSURL URLWithString:
                     [NSString stringWithFormat:@"http://httpbin.org/%@", [[self method] lowercaseString]]
                     ]];
    [request setMethod:[self method]];
    [request send:form];
}

-(void)onImageClick:(id)arg
{
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [[self photoView] setImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)tiRequest:(TiRequest *)request onError:(TiResponse *)response
{
    Alert(@"Error", [[response error] localizedDescription]);
}

-(void)tiRequest:(TiRequest *)request onLoad:(TiResponse *)response
{
    Alert(@"Success", @"Please see log");
    PELog(@"%@", [response responseDictionary]);
}
- (void)dealloc {
    [_photoView release];
    [_firstNameField release];
    [_lastNameField release];
    [_bottomSpace release];
    [_scrollView release];
    [super dealloc];
}
@end
