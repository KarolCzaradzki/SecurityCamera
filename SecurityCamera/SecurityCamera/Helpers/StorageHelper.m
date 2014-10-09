//
//  StorageHelper.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "StorageHelper.h"

@implementation StorageHelper

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

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
