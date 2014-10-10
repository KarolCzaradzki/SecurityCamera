//
//  StoredImage.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "StoredImage.h"
#import "UIImage+Thumbnail.h"

@implementation StoredImage

@synthesize imagePath;
@synthesize imageThumbnail;
@synthesize timestamp;

-(void)dealloc
{
    self.imagePath = nil;
    self.imageThumbnail = nil;
    self.timestamp = nil;
}

-(UIImage*) image
{
    //Don't store this one in memory cause it may cause memory warning
    return [UIImage imageWithContentsOfFile:[self imageFullPath]];
}


-(NSDictionary*) serialize
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"timestamp"] = self.timestamp;
    dictionary[@"path"] = self.imagePath;
    return dictionary;
}

-(void) deserialize:(NSDictionary*)dictionary
{
    self.timestamp = dictionary[@"timestamp"];
    self.imagePath = dictionary[@"path"];
    self.imageThumbnail = [UIImage imageWithContentsOfFile:[self thumbnailFullPath]];
}

- (void) erase
{
    [[NSFileManager defaultManager] removeItemAtPath:[self imageFullPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self thumbnailFullPath] error:nil];
}

- (float) getHardDriveSize
{
    float resultSize = 0;
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self imageFullPath] error:nil];
    resultSize += [[fileAttributes objectForKey:NSFileSize] floatValue];
    
    fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self thumbnailFullPath] error:nil];
    resultSize += [[fileAttributes objectForKey:NSFileSize] floatValue];
    
    return resultSize/(1024.0f*1024.0f);
}

- (NSDate*) timestampDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    return [formatter dateFromString:timestamp];
}

+ (NSString*)saveData:(NSData*)data withName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    [data writeToFile:filePath atomically:NO];
    
    return filePath;
}

+ (NSString*)makeName:(NSString*)input
{
    NSMutableString *result = [input mutableCopy];
    [result replaceOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, result.length)];
    [result replaceOccurrencesOfString:@"." withString:@"" options:0 range:NSMakeRange(0, result.length)];
    return result;
}

+ (StoredImage*)createStorageImageAndSave:(UIImage*)image timestamp:(NSDate*)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *timestampString =  [formatter stringFromDate:timestamp];
    
    //Saving image
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString* imageName = [self makeName:timestampString];
    imageName = [imageName stringByAppendingString:@".png"];;
    [StoredImage saveData:imageData withName:imageName];
    
    //Saving thumbnail
    UIImage *thumbnail = [image thumbnail];
    imageData = UIImagePNGRepresentation(thumbnail);
    NSString* thumbnailPath = [self makeName:timestampString];
    thumbnailPath = [thumbnailPath stringByAppendingString:@"_thumb.png"];
    [StoredImage saveData:imageData withName:thumbnailPath];
    
    //Creating new data srouce
    StoredImage *newDataSource = [[StoredImage alloc] init];
    newDataSource.imageThumbnail = thumbnail;
    newDataSource.imagePath = imageName;
    newDataSource.timestamp = timestampString;
    return newDataSource;
}

#pragma mark Path builder
- (NSString*)imageFullPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, imagePath];
}

- (NSString*)thumbnailFullPath
{
    NSString *thumbnailPath = [self.imagePath stringByReplacingOccurrencesOfString:@".png" withString:@"_thumb.png"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, thumbnailPath];
}
@end
