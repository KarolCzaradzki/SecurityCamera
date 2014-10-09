//
//  SimpleImageCell.h
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoredImage.h"

@interface SimpleImageCell : UITableViewCell{
    
}

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *timestampLabel;

- (id)init;
- (void)loadData:(StoredImage*)data;

+ (uint)cellHeight;

@end
