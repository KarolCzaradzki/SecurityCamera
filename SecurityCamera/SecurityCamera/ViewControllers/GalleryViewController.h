//
//  GalleryViewController.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredImage.h"

@protocol GallerViewControllerDelegate;

@interface GalleryViewController : UIViewController

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,weak) StoredImage *storedImage;
@property (nonatomic,weak) id<GallerViewControllerDelegate> delegate;

- (void)loadData:(StoredImage*)storedImage;

@end

@protocol GallerViewControllerDelegate <NSObject>

- (void)galleryViewControllerDidClose:(GalleryViewController*)controller;
- (void)galleryViewController:(GalleryViewController*)controller didRemovedData:(StoredImage*)dataSource;

@end