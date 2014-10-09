//
//  CameraViewController.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "ImageHelper.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize cameraImageView;
@synthesize photoTimer;
@synthesize stillImageOutput;
@synthesize lastMotionImageDateLabel;
@synthesize lastMotionImageView;
@synthesize lastMotionDiffImageView;

#pragma mark Lifecycle
- (void)dealloc
{
    [self.photoTimer invalidate];
    self.cameraImageView = nil;
    self.stillImageOutput = nil;
    self.photoTimer = nil;
    self.lastMotionImageView = nil;
    self.lastMotionImageDateLabel = nil;
    self.lastMotionDiffImageView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCameraImageView];
    [self createLastMotionImageViewAndLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startStreamingFromCamera];
    [self initializeTimer];
}

- (void)initializeTimer
{
    self.photoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(capturePicture) userInfo:nil repeats:NO];
}

- (void)startStreamingFromCamera
{
    //Creating session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    //Creating layer that video will be stream on
    CALayer *viewLayer = self.cameraImageView.layer;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = self.cameraImageView.bounds;
    [viewLayer addSublayer:captureVideoPreviewLayer];
    
    //Initializing capture device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
        return;
    }
    
    //Adding image output
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    
    //Starting session
    [session addInput:input];
    [session startRunning];
}

#pragma mark Picture handling
- (void)capturePicture
{
    //Finding valid connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //No connection found
    if(!videoConnection)
    {
        [self initializeTimer];
        return;
    }
    
    //Getting image
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         [self performSelectorInBackground:@selector(analyzeImage:) withObject:image];
     }];
}

- (void)analyzeImage:(UIImage*)image
{
    if(![[ImageHelper sharedInstance] pushImageAndCompare:image])
    {
        [self performSelectorOnMainThread:@selector(newImageCaptured:) withObject:image waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(noMotionDetected) withObject:image waitUntilDone:NO];
    }
    
}

- (void)noMotionDetected
{
    //Restarting timer
   [self initializeTimer];
}
- (void)newImageCaptured:(UIImage*)image
{
    //Setting new image
    self.lastMotionImageView.image = [ImageHelper sharedInstance].lastMotionImage;
    self.lastMotionDiffImageView.image = [ImageHelper sharedInstance].lastMotionDifferenceImage;
    
    //Setting date string
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSString *formatedString = [NSString stringWithFormat:@"Last image captured: %@",dateString];
    lastMotionImageDateLabel.text = formatedString;
    
    //Restarting timer
    [self initializeTimer];
}

#pragma mark Creating view
- (void)createCameraImageView
{
    self.cameraImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.cameraImageView];
    
    //Frame
    CGRect imageViewFrame;
    imageViewFrame.origin = CGPointMake(0,0);
    imageViewFrame.size = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height/2);
    self.cameraImageView.frame = imageViewFrame;
    
    //Debug
    self.cameraImageView.backgroundColor = [UIColor whiteColor];
}

- (void)createLastMotionImageViewAndLabel
{
    //Creating image view for last captured image with motion
    self.lastMotionImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.lastMotionImageView];
    
    //Frame
    CGRect imageViewFrame;
    imageViewFrame.origin = CGPointMake(0,self.view.bounds.size.height/2 + 10);
    imageViewFrame.size = CGSizeMake(self.view.bounds.size.width/2,
                                     self.view.bounds.size.height/3);
    self.lastMotionImageView.frame = imageViewFrame;
    self.lastMotionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //Creating image view for last captured significant difference in motion
    lastMotionDiffImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.lastMotionDiffImageView];
    
    //Frame
    imageViewFrame.origin = CGPointMake(self.view.bounds.size.width/2,
                                        self.view.bounds.size.height/2 + 10);
    imageViewFrame.size = CGSizeMake(self.view.bounds.size.width/2 ,
                                     self.view.bounds.size.height/3);
    self.lastMotionDiffImageView.frame = imageViewFrame;
    self.lastMotionDiffImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //Creating label
    self.lastMotionImageDateLabel = [[UILabel alloc] init];
    [self.view addSubview:self.lastMotionImageDateLabel];
    
    [lastMotionImageDateLabel setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [lastMotionImageDateLabel setCenter:CGPointMake(self.view.bounds.size.width/2,imageViewFrame.origin.y+imageViewFrame.size.height+25)];
    lastMotionImageDateLabel.text = @"No Image Captured";
    lastMotionImageDateLabel.textAlignment = NSTextAlignmentCenter;
    
    //Debug
    self.lastMotionImageView.backgroundColor = [UIColor whiteColor];
    self.lastMotionImageDateLabel.backgroundColor = [UIColor whiteColor];
}

@end
