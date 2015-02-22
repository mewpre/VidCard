//
//  ConfirmViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "ConfirmViewController.h"
#import <Parse/Parse.h>
#import <LivePaperSDK/LivePaperSDK.h>
#import "Crittercism.h"

#define CLIENT_ID       @"a57exuakm5c0rhubs6mb7e3a4ptrh1c3"
#define CLIENT_SECRET   @"CKwaHbrPyXrdPmowosAg7zKPvNxqW3lh"

@interface ConfirmViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property LPSession *lpSession;

@property NSDictionary *richPayoffDict;

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.spinner.hidden = YES;
    self.imageView.image = self.photoImage;
    [self loadWebPageWithAddress: self.url];
    self.lpSession = [LPSession createSessionWithClientID:CLIENT_ID secret:CLIENT_SECRET];
}

- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    NSString *name = @"Watermark from iOS";
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [self generateRichPayoffDictionary];
    [self.lpSession createWatermark:name richPayoffData:self.richPayoffDict publicURL:[NSURL URLWithString: self.url] image:self.photoImage completionHandler:^(UIImage *watermarkedImage, NSError *error)
    {
        if (!error)
        {
            [Crittercism leaveBreadcrumb:@"User tapped start button"];
            NSData *imageData = UIImageJPEGRepresentation(watermarkedImage, 1.0);
            PFFile *imageFile = [PFFile fileWithName:@"Photo.png" data:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (!error)
                 {
                     PFObject *photoObject = [PFObject objectWithClassName:@"Photo"];
                     photoObject[@"imageFile"] = imageFile;
                     [photoObject setObject:[PFUser currentUser] forKey:@"user"];
                     [photoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                      {
                          PFObject *videoObject = [PFObject objectWithClassName:@"Video"];
                          videoObject[@"videoURL"] = self.url;
                          videoObject[@"photo"] = photoObject;
                          [videoObject saveInBackground];
                      }];
                     [self.spinner stopAnimating];
                     self.spinner.hidden = YES;
                     self.tabBarController.selectedIndex = 1;
                     [self.navigationController popToRootViewControllerAnimated: NO];
                 }
             }];
        }

    }];
}

#pragma mark WEBVIEW DELEGATES
// Loads an address on the webview
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
    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}

- (void)generateRichPayoffDictionary
{
    self.richPayoffDict = @{
                            @"type" : @"content action layout",
                            @"version" : @"1",
                            @"data" : @{
                                    @"content" : @{
                                            @"type": @"video",
                                            @"label": @"VidCard video",
                                            @"analyticId": @"UA-38834658-3",
                                            @"data": @{
                                                    @"URL": self.url,
                                                    @"fullscreen": @true,
                                                    @"autoplay": @true
                                                    }
                                            },

                                    @"actions" : @[
                                            @{
                                                @"type" : @"share",
                                                @"label" : @"Share!",
                                                @"icon" : @{ @"id" : @"527" },
                                                @"data" : @{ @"URL" : [NSString stringWithFormat: @"Check out this Vidcard video! %@", self.url]}
                                                }
                                            ]
                                    }
                            };
}

@end
