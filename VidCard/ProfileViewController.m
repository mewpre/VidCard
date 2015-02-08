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
@property NSArray *arrayOfImages;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfImages = [NSArray arrayWithObjects:@"http://www.deejstuff.com/images/cherryButterfly.png", @"http://upload.wikimedia.org/wikipedia/commons/9/93/Hemerocallis_lilioasphodelus_flower.jpg", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self login];
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
    return self.arrayOfImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSURL *url = [NSURL URLWithString:self.arrayOfImages[indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.selectedImage = image;
    cell.imageView.image = image;
    return cell;
}

#pragma mark SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedVidCardViewController *selectedVCVC = [segue destinationViewController];
    selectedVCVC.image = self.selectedImage;
}

@end
