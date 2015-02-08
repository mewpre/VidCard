//
//  ProfileViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "ProfileViewController.h"
#import "SelectedVidCardViewController.h"
#import <Parse/Parse.h>
#import "MyLoginViewController.h"


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property UIImage *selectedImage;
@property NSArray *arrayOfImageObjects;
@property NSMutableArray *arrayOfImages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfImages = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self login];
    [self getAllPhotosByUser];
}

- (void)getAllPhotosByUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.arrayOfImageObjects = [objects mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)login {
    if (![PFUser currentUser])
    {

        MyLoginViewController *loginViewController = [[MyLoginViewController alloc]init];
        [loginViewController setDelegate:self];

        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc]init];
        [signUpViewController setDelegate:self];

        [loginViewController setSignUpController:signUpViewController];

        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onLogoutButtonPressed:(UIBarButtonItem *)sender
{
    [PFUser logOut];
    [self login];
}

#pragma mark TABLE VIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfImageObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *imageObject = self.arrayOfImageObjects[indexPath.row];
    PFFile *imageFile = imageObject[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
     {
         UIImage *image = [UIImage imageWithData:data];
         cell.imageView.image = image;
         [self.arrayOfImages addObject:image];
     }];
    cell.textLabel.text = @"table";
    return cell;
}

#pragma mark SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedVidCardViewController *selectedVCVC = [segue destinationViewController];
    self.selectedImage = self.arrayOfImages[self.tableView.indexPathForSelectedRow.row];
    selectedVCVC.image = self.selectedImage;
}

@end
