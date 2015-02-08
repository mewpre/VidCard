//
//  RecordVideoViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h> 
#import <MobileCoreServices/MobileCoreServices.h> 


@interface RecordVideoViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>
@property NSURL *videoURL;
@property MPMoviePlayerController *videoController;






@end

@implementation RecordVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


@end
