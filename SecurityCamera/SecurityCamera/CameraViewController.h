//
//  CameraViewController.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : UIViewController {
    
}

@property (nonatomic,strong) UIImageView *cameraImageView;
@property (nonatomic,strong) UIImageView *lastMotionImageView;
@property (nonatomic,strong) UILabel *lastMotionImageDateLabel;
@property (nonatomic,strong) NSTimer *photoTimer;
@property (nonatomic,strong) AVCaptureStillImageOutput* stillImageOutput;

@end

