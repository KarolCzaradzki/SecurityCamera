//
//  StorageHelper.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StoredImage.h"

@interface StorageHelper : NSObject {

}

@property (nonatomic,readonly) NSMutableArray *storedImages;

- (void)synchronize;
- (void)addImage:(UIImage*)image withTimestamp:(NSString*)timestamp;
- (void)saveData:(NSData*)data withName:(NSString*)name;

+(StorageHelper*) sharedInstance;

@end
