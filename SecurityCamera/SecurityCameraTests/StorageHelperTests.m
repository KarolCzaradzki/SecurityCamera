//
//  SecurityCameraTests.m
//  SecurityCameraTests
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StorageHelper.h"
#import "StoredImage.h"

@interface ImageManipulationTests : XCTestCase {
    UIImage *lena1;
    UIImage *lena2;
}

@end

@implementation ImageManipulationTests

- (void)setUp {
    [super setUp];

    //Loading test assets
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"lena1" ofType:@"png"];
    lena1 = [UIImage imageWithContentsOfFile:imagePath];
    imagePath = [bundle pathForResource:@"lena2" ofType:@"png"];
    lena2 = [UIImage imageWithContentsOfFile:imagePath];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//Test if image is saved properly
- (void)testImageSave {
    [[StorageHelper sharedInstance] removeAllImages];
    [[StorageHelper sharedInstance] addImage:lena1 withTimestamp:[NSDate date]];
    StoredImage *storedImage = [StorageHelper sharedInstance].storedImages.lastObject;
    bool image = [[NSFileManager defaultManager] fileExistsAtPath:[storedImage imageFullPath]];
    
    XCTAssert(image, @"Pass");
}

//Test if thumbnail is saved properly
- (void)testThumbImageSave {
    [[StorageHelper sharedInstance] removeAllImages];
    [[StorageHelper sharedInstance] addImage:lena1 withTimestamp:[NSDate date]];
    StoredImage *storedImage = [StorageHelper sharedInstance].storedImages.lastObject;
    bool thumb = [[NSFileManager defaultManager] fileExistsAtPath:[storedImage thumbnailFullPath]];
    
    XCTAssert(thumb, @"Pass");
}

//Test if thumbnail is created properly
- (void)testThumbnailCreate {
    [[StorageHelper sharedInstance] addImage:lena1 withTimestamp:[NSDate date]];
    StoredImage *storedImage = [StorageHelper sharedInstance].storedImages.lastObject;
    UIImage *image = storedImage.imageThumbnail;
    
    XCTAssert(image != NULL, @"Pass");
}

//Test if data source is completly released
- (void)testDataSourceErase {
    [[StorageHelper sharedInstance] removeAllImages];
    
    [[StorageHelper sharedInstance] addImage:lena1 withTimestamp:[NSDate date]];
    StoredImage *dataSourceForImage = [[StorageHelper sharedInstance].storedImages firstObject];
    [[StorageHelper sharedInstance] removeImage:dataSourceForImage];
    
    //Checking if image has been removed from the hard drive
    bool thumb = [[NSFileManager defaultManager] fileExistsAtPath:[dataSourceForImage thumbnailFullPath]];
    bool image = [[NSFileManager defaultManager] fileExistsAtPath:[dataSourceForImage imageFullPath]];
    XCTAssert(!thumb, @"Thumbnail still exists on hard drive");
    XCTAssert(!image, @"Image still exists on hard drive");
}

//Test if memory limit works
- (void)testMemoryLimitManagment {
    
    for(int i = 0; i < 200; i++)
    {
        [[StorageHelper sharedInstance] addImage:lena1 withTimestamp:[NSDate dateWithTimeIntervalSince1970:i]];
        XCTAssert([[StorageHelper sharedInstance] getUsedHardDriveSpace] < 100.0f, @"Pass");
    }
    
}


@end
