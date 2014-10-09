//
//  ImageHelper.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

@synthesize lastImage;

- (bool)pushImageAndCompare:(UIImage*)image
{
    if(!lastImage) {
        lastImage = image;
        return YES; //No motion detected
    } else {
        lastImage = image;
        return NO;
    }
}

- (UIImage*)imageFromLayer:(CALayer*)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+(ImageHelper*) sharedInstance
{
    static ImageHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

@end
