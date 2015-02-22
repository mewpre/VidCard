//
//  RecordVideoViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "RecordVideoViewController.h"
#import "AddURLViewController.h"
#import <MediaPlayer/MediaPlayer.h> 
#import <MobileCoreServices/MobileCoreServices.h>
#import "ConfirmViewController.h"


@interface RecordVideoViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>
@property NSURL *videoURL;
@property MPMoviePlayerController *videoController;
@property NSString *addedVideoURL;

@end

@implementation RecordVideoViewController
/** 
 TODO: Updated SDK requires that video URLS lead to .mp4 files, so we should add functionality to record videos as .mp4s, upload them somewhere, and retrieve the url
**/
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onCameraButtonTapped:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addURLAction = [UIAlertAction actionWithTitle:@"Paste Video URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier: @"AddURLSegue" sender: self];
    }];
//    UIAlertAction *recordVideoAction = [UIAlertAction actionWithTitle:@"Record Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:addURLAction];
//    [alertController addAction:recordVideoAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:nil];

    self.videoController = [[MPMoviePlayerController alloc]init];

    [self.videoController setContentURL:self.videoURL];
    [self.videoController.view setFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:self.videoController.view];

    [self.videoController play];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConfirmSegue"])
    {
        ConfirmViewController *vc = segue.destinationViewController;
        vc.photoImage = self.photoImage;
        vc.url = self.addedVideoURL;
    }
    else if ([segue.identifier isEqualToString:@"AddURLSegue"])
    {
        AddURLViewController *auvc = segue.destinationViewController;
        auvc.photoImage = self.photoImage;
    }
}

#pragma mark UNWIND
// Gets the newly added url from the modal that popped up
- (IBAction)unwindFromAddURL:(UIStoryboardSegue *)segue
{
    AddURLViewController *addUVC = segue.sourceViewController;
    self.addedVideoURL = [addUVC addedURL];
    self.photoImage = [addUVC addedPhotoImage];
}

@end
