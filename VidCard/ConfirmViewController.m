//
//  ConfirmViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "ConfirmViewController.h"
#import <Parse/Parse.h>

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{

    NSData *imageData = UIImagePNGRepresentation(self.photoImage);
    PFFile *imageFile = [PFFile fileWithName:@"Photo.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"merpppp");
             PFObject *photoObject = [PFObject objectWithClassName:@"Photo"];
             photoObject[@"imageFile"] = imageFile;
             [photoObject setObject:[PFUser currentUser] forKey:@"createdBy"];
             [photoObject saveInBackground];

             
         }
     }];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
