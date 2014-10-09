//
//  SimpleImageCell.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "SimpleImageCell.h"

@implementation SimpleImageCell
@synthesize timestampLabel;
@synthesize imageView;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self createUI];
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.timestampLabel = nil;
}

#pragma mark Interface
- (void) createUI
{
    //Creating image view
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(5,5,50,50);
    [self addSubview:self.imageView];
    
    //Creating timestamp label
    self.timestampLabel = [[UILabel alloc] init];
    self.timestampLabel.frame = CGRectMake(60,5,300,50);
    [self addSubview:self.timestampLabel];
}

#pragma mark Reusable load data
- (void)loadData:(StoredImage*)data
{
    self.imageView.image = data.imageThumbnail;
    self.timestampLabel.text = data.timestamp;
}

#pragma mark Class static properties
+ (uint)cellHeight
{
    return 60;
}
@end
