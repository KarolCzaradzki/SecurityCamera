//
//  StoredImage.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StoredImage : NSObject {
    
}

@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) UIImage  *imageThumbnail;
@property (nonatomic,readonly) UIImage  *image;
@property (nonatomic,strong) NSString *timestamp;

// Serialization
- (NSDictionary*)serialize;
- (void) deserialize:(NSDictionary*)dictionary;

// Managing hard drive data
- (void) erase;
- (float) getHardDriveSize;

// Getting timestamp as NSDate
- (NSDate*) timestampDate;

//Factory
+ (StoredImage*)createStorageImageAndSave:(UIImage*)image timestamp:(NSString*)timestamp;

@end
