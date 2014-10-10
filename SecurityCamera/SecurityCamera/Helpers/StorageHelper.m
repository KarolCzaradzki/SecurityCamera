//
//  StorageHelper.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "StorageHelper.h"
#import "ImageHelper.h"
#import "UIImage+Thumbnail.h"
#import "StoredImage.h"

#define MAX_SPACE_ON_HARD_DRIVE 100.0f //In megabytes

@implementation StorageHelper

@synthesize storedImages;

-(id)init
{
    self = [super init];
    if(self)
    {
        storedImages = [[NSMutableArray alloc] init];
        [self load];
    }
    return self;
}

- (void)addImage:(UIImage*)image withTimestamp:(NSDate*)timestamp
{
    StoredImage *newStoredImage = [StoredImage createStorageImageAndSave:image timestamp:timestamp];
    [storedImages addObject:newStoredImage];
    
    [self synchronize];
}

#pragma mark Database operations
- (NSString*)buildDataBaseUrl
{
    //Getting path to database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"database.arr"];
    return filePath;
}

- (void)load
{
    NSMutableArray *descriptions = [[NSMutableArray alloc] initWithContentsOfFile:[self buildDataBaseUrl]];
    for(NSDictionary *dictionary in descriptions)
    {
        StoredImage *item = [[StoredImage alloc] init];
        [item deserialize:dictionary];
        [storedImages addObject:item];
    }
}

- (void)synchronize
{
    [self sortDataByDate];
    [self removeOldImages];
    
    //Serializing objects
    NSMutableArray *descriptions = [[NSMutableArray alloc] init];
    for(StoredImage *item in storedImages)
    {
        [descriptions addObject:[item serialize]];
    }
    
    [descriptions writeToFile:[self buildDataBaseUrl] atomically:NO];
}

- (void)sortDataByDate
{
    [storedImages sortUsingComparator:^NSComparisonResult(StoredImage* obj1, StoredImage* obj2) {
        return [obj1.timestampDate compare:obj2.timestampDate];
    }];
}

#pragma mark Calculating used space
- (float)getUsedHardDriveSpace
{
    float totalSize = 0.0f;
    for(StoredImage *image in storedImages)
    {
        totalSize += [image getHardDriveSize];
    }
    return totalSize;
}

#pragma mark Removing images
- (void)removeImage:(StoredImage*)dataSource
{
    [dataSource erase];
    [storedImages removeObject:dataSource];
    [self synchronize];
}

- (void)removeOldImages
{
    float totalSize = 0.0f;
    for(StoredImage *image in storedImages)
    {
        totalSize += [image getHardDriveSize];
    }
    
    while(totalSize >= MAX_SPACE_ON_HARD_DRIVE)
    {
        StoredImage *image = [storedImages firstObject];
        totalSize -= [image getHardDriveSize];
        [self removeImage:image];
    }
}

- (void)removeAllImages
{
    while(storedImages.firstObject)
    {
        [self removeImage:storedImages.firstObject];
    }
}

#pragma mark Singleton
+(StorageHelper*) sharedInstance
{
    static StorageHelper *helper = nil;
    if(!helper) {
        helper = [[self alloc] init];
    }
    return helper;
}

@end
