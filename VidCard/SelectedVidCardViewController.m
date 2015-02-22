//
//  SelectedVidCardViewController.m
//  VidCard
//
//  Created by Tewodros Wondimu on 2/8/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "SelectedVidCardViewController.h"

@interface SelectedVidCardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SelectedVidCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageView.image = self.image;
}

- (IBAction)onPrintButtonPressed:(UIButton *)sender
{
    NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
    if (imageData) {
        [self printImage:imageData andImageDescription:
         @"Awesome Image Printing"];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Image" message:@"Get water marked image before printing" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)printImage:(NSData *)imageData andImageDescription:(NSString *)jobDescription {
    // Check whether the image is printable
    if ([UIPrintInteractionController canPrintData:imageData]) {
        // Create an instance of the UIPrintInteractionController
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];

        // Gives the printer what to print
        controller.printingItem = imageData;

        // Print job info that is displayed inside the app to the user what is about to be printed
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];

        // Output type - The type of content
        // General, Grayscale, Photo (highquality)
        // UIPrintInfoOutputPhoto, UIPrintInfoOutputPhotoGrayscale
        printInfo.outputType = UIPrintInfoOutputPhoto;

        // The name of the print job
        printInfo.jobName = [NSString stringWithFormat:@"%@", jobDescription];

        controller.printInfo = printInfo;

        [controller presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
            if (!error)
            {
                NSLog(@"%@", error);
            }
            else
            {
                NSLog(@"Print Succeeded");
            }
        }];
    }
}



@end
