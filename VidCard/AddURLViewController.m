//
//  AddURLViewController.m
//  VidCard
//
//  Created by Tewodros Wondimu on 2/8/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "AddURLViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AddURLViewController () <UITextFieldDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *useButton;

@end

@implementation AddURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.spinner.hidden = YES;
    self.useButton.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    BOOL urlValidate = [self validateUrl:textField.text];
    BOOL urlValidate = true;
    if (urlValidate) {
        [self loadWebPageWithAddress:textField.text];
    }
    else {
        NSLog(@"Invalid URL");
    }
    return true;
}

- (NSString *)addedURL
{
    return self.urlTextField.text;
}

- (UIImage *)addedPhotoImage
{
    return self.photoImage;
}

#pragma mark WEBVIEW DELEGATES

// Loads an andress on the webview
- (void)loadWebPageWithAddress:(NSString *)addressString
{
    float width, height;
    width = 280.0;
    height = 200.0;
    NSString *html = [NSString stringWithFormat:@"\
                      <html><head>\
                      <style type=\"text/css\">\
                      body {\
                      background-color: transparent;\
                      color: white;\
                      }\
                      </style>\
                      </head><body style=\"margin:0\">\
                      <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                      width=\"%0.0f\" height=\"%0.0f\"></embed>\
                      </body></html>", addressString, width, height];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.spinner.hidden = NO;
    self.useButton.hidden = YES;
    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    self.useButton.hidden = NO;
}

#pragma mark BUTTON

- (IBAction)onCloseButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
