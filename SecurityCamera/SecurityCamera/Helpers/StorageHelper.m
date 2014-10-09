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

@implementation StorageHelper

@synthesize storedImages;

-(id)init
{
    self = [super init];
    if(self)
    {
        storedImages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addImage:(UIImage*)image withTimestamp:(NSString*)timestamp
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

    //Serializing objects
    NSMutableArray *descriptions = [[NSMutableArray alloc] init];
    for(StoredImage *item in storedImages)
    {
        [descriptions addObject:[item serialize]];
    }
    
    [descriptions writeToFile:[self buildDataBaseUrl] atomically:NO];
}

#pragma mark Singleton
+(StorageHelper*) sharedInstance
{
    static StorageHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

@end
