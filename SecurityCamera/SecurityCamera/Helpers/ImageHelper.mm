//
//  ImageHelper.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "ImageHelper.h"

//Ugly trick for opencv to compile
#import <opencv2/opencv.hpp>
#import <opencv2/core/core.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/imgproc/imgproc.hpp>

@implementation ImageHelper

@synthesize lastImage;
@synthesize lastMotionImage;
@synthesize lastMotionDifferenceImage;

- (void)dealloc
{
    self.lastMotionImage = nil;
    self.lastMotionDifferenceImage = nil;
    self.lastImage = nil;
}

#pragma mark Base

- (bool)pushImageAndCompareWithPrevious:(UIImage*)image
{
    if(!lastImage) {
        lastImage = image;
        return YES; //No motion detected
    } else {
        bool result = [self compareImage:image withImage:lastImage];
        lastImage = image;
        return result;
    }
}

#pragma mark Image manipulation

- (bool)compareImage:(UIImage*)imageA withImage:(UIImage*)imageB
{
    cv::Mat matA = [self cvMatFromUIImage:imageA];
    cv::Mat matB = [self cvMatFromUIImage:imageB];
    cv::Mat result;
    
    //Simple "motion detection"
    absdiff(matA, matB, result);
    cvtColor(result, result, cv::COLOR_BGR2GRAY);
    threshold(result, result, 35, 255, cv::THRESH_BINARY);
    
    int numberOfChanges = 0;
    for(int j = 0; j < result.rows; j+=2){ // height
        for(int i = 0; i < result.cols; i+=2){ // width
            if(static_cast<uchar>(result.at<uchar>(j,i)) == 255)
            {
                numberOfChanges++;
            }
        }
    }
    
    int threesholdNumberOfChanges = result.rows*result.cols/30;
    if(numberOfChanges > threesholdNumberOfChanges)
    {
        self.lastMotionImage = imageA;
        self.lastMotionDifferenceImage = [self UIImageFromCVMat:result];
        return false;
    }
    else
    {
        return true;
    }
}



#pragma mark Conversions to UIImage

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    if  (image.imageOrientation == UIImageOrientationLeft
         || image.imageOrientation == UIImageOrientationRight) {
        cols = image.size.height;
        rows = image.size.width;
    }

    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

#pragma mark Singleton
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
