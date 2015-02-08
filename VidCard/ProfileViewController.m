//
//  ProfileViewController.m
//  VidCard
//
//  Created by Mary Jenel Myers on 2/7/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "ProfileViewController.h"
#import "SelectedVidCardViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property UIImage *selectedImage;
@property NSArray *arrayOfImages;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfImages = [NSArray arrayWithObjects:@"http://www.deejstuff.com/images/cherryButterfly.png", @"http://upload.wikimedia.org/wikipedia/commons/9/93/Hemerocallis_lilioasphodelus_flower.jpg", nil];
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
