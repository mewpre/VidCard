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
#import "CustomCollectionViewCell.h"


@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property UIImage *selectedImage;
@property NSArray *arrayOfImageObjects;
@property NSMutableArray *arrayOfImages;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property UIImagePickerController *imagePicker;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = [PFUser currentUser].username;

    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.arrayOfImages = [NSMutableArray new];
    self.profileNameLabel.text = [PFUser currentUser].username;
    [self getAllPhotosByUser];
    if ([PFUser currentUser])
    {
        PFFile *imagefile = [[PFUser currentUser] objectForKey:@"profilePhoto"];
        [imagefile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
         {
             UIImage *image = [UIImage imageWithData:data];
             self.profileImageView.image = image;
             self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
             self.profileImageView.clipsToBounds = YES;
         }];
    }

    self.tabBarController.tabBar.translucent = false;
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
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
        if (!self.arrayOfImages.count) {
            for (PFObject *imageObject in objects) {
                PFFile *imageFile = imageObject[@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                 {
                     UIImage *image = [UIImage imageWithData:data];
                     [self.arrayOfImages addObject:image];
                     [self.collectionView reloadData];
                 }];
            }
        }
    }];
}

- (void)login
{
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

- (IBAction)onProfilePictureTapped:(UITapGestureRecognizer *)sender
{
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.profileImageView.image = image;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"ProfilePicture.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error) {
             PFObject *user = [PFUser currentUser];
             user[@"profilePhoto"] = imageFile;
             [user saveInBackground];
         }
     }];
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

#pragma mark COLLECTION VIEW
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    cell.imageView.image = self.arrayOfImages[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayOfImages.count;
}

#pragma mark SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SelectedVidCardViewController *selectedVCVC = [segue destinationViewController];
    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    self.selectedImage = self.arrayOfImages[indexPath.row];
    selectedVCVC.image = self.selectedImage;
}

@end
