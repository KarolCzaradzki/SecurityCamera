//
//  SecurityCameraTests.m
//  SecurityCameraTests
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ImageHelper.h"

@interface StorageHelperTests : XCTestCase {
    UIImage *lena1;
    UIImage *lena2;
}

@end

@implementation StorageHelperTests

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
    [super tearDown];
}


//Tests comparision of same images
- (void)testSameImages {
    [[ImageHelper sharedInstance] pushImageAndCompareWithPrevious:lena1];
    bool result = [[ImageHelper sharedInstance] pushImageAndCompareWithPrevious:lena1];
    XCTAssert(result, @"Images are the same");
}

//Tests comparision of visibly different images
- (void)testDifferentImages {
    [[ImageHelper sharedInstance] pushImageAndCompareWithPrevious:lena1];
    bool result = [[ImageHelper sharedInstance] pushImageAndCompareWithPrevious:lena2];
    XCTAssert(!result, @"Images are different");
}


@end

