//
//  GalleryViewController.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "GalleryViewController.h"

@implementation GalleryViewController

@synthesize imageView;
@synthesize storedImage;
@synthesize delegate;

#pragma mark Lifecycle
- (void)dealloc
{
    self.imageView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addImageView];
    [self addButtons];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(BOOL)shouldAutorotate
{
    // SAY NOT TO ORIENTATION CHANGE !
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark Interface
- (void)addImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    [self.view addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(self.storedImage) {
        self.imageView.image = self.storedImage.image;
    }
}

- (void)addButtons
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 100, 40);
    backButton.center = CGPointMake((self.view.bounds.size.width/4),self.view.bounds.size.height-75);
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:deleteButton];
    deleteButton.frame = CGRectMake(0, 0, 100, 40);
    deleteButton.center = CGPointMake(((self.view.bounds.size.width*3)/4),self.view.bounds.size.height-75);
    [deleteButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
}

#pragma mark Loading data
- (void)loadData:(StoredImage*)data
{
    self.imageView.image = data.image;
    self.storedImage = data;
}

#pragma mark UserInteraction
- (void)onBack
{
    [self.delegate galleryViewControllerDidClose:self];
}

- (void)onDelete
{
    [self.delegate galleryViewController:self didRemovedData:storedImage];
}

@end
