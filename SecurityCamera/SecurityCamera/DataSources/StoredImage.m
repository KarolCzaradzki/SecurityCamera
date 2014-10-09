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
    return [UIImage imageWithContentsOfFile:imagePath];
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
    NSString *thumbnailPath = [self.imagePath stringByReplacingOccurrencesOfString:@".png" withString:@"_thumb.png"];
    NSData *data = [NSData dataWithContentsOfFile:self.imagePath];
    self.imageThumbnail = [UIImage imageWithContentsOfFile:thumbnailPath];
}

+ (NSString*)saveData:(NSData*)data withName:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, name];
    [data writeToFile:filePath atomically:YES];
    
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

+ (StoredImage*)createStorageImageAndSave:(UIImage*)image timestamp:(NSString*)timestamp
{
    //Saving image
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString* imageName = [self makeName:timestamp];
    
    imageName = [imageName stringByAppendingString:@".png"];
    NSString *imagePath = [StoredImage saveData:imageData withName:imageName];
    
    //Saving thumbnail
    UIImage *thumbnail = [image thumbnail];
    imageData = UIImagePNGRepresentation(thumbnail);
    NSString* thumbnailPath = [self makeName:timestamp];
    thumbnailPath = [thumbnailPath stringByAppendingString:@"_thumb.png"];
    [StoredImage saveData:imageData withName:thumbnailPath];
    
    //Creating new data srouce
    StoredImage *newDataSource = [[StoredImage alloc] init];
    newDataSource.imageThumbnail = thumbnail;
    newDataSource.imagePath = imagePath;
    newDataSource.timestamp = timestamp;
    return newDataSource;
}

@end
