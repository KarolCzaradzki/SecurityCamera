//
//  ImageHelper.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject {
    
}

@property (nonatomic,retain) UIImage* lastImage;
@property (nonatomic,retain) UIImage* lastMotionImage;
@property (nonatomic,retain) UIImage* lastMotionDifferenceImage;

//If there is significant difference between images the result will be
- (bool)pushImageAndCompare:(UIImage*)image;

+(ImageHelper*) sharedInstance;

@end
