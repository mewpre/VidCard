//
//  TakePhotoViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "RecordVideoViewController.h"

@interface TakePhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *photoImage;
@property PFObject *currentPhoto;
@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;

}

- (IBAction)onCameraButtonPressed:(UIButton *)sender

{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *chooseFromPhotos = [UIAlertAction actionWithTitle:@"Choose From Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:takePhotoAction];
    [alertController addAction:chooseFromPhotos];
    [self presentViewController:alertController animated:YES completion:^{

    }];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecordVideoViewController *vc = segue.destinationViewController;
    vc.photoImage = self.photoImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageView.image = image;
    self.photoImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
