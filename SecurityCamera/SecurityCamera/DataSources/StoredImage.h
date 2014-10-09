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

- (NSDictionary*)serialize;
- (void) deserialize:(NSDictionary*)dictionary;

+ (StoredImage*)createStorageImageAndSave:(UIImage*)image timestamp:(NSString*)timestamp;

@end
