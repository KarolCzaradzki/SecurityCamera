//
//  UIImage.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage*)thumbnail;
- (UIImage *)resizeImage:(CGSize)newSize;

@end
