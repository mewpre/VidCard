//
//  MyLoginViewController.m
//  VidCard
//
//  Created by Tewodros Wondimu on 2/8/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "MyLoginViewController.h"

@interface MyLoginViewController ()

@end

@implementation MyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.logInView.dismissButton setHidden:YES];

    [self.logInView setBackgroundColor:[UIColor blackColor]];

//    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AudioGram"]]];
}


@end
