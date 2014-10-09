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

- (bool)pushImageAndCompare:(UIImage*)image;

+(ImageHelper*) sharedInstance;

@end
