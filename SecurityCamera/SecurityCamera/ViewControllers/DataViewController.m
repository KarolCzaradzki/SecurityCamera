//
//  DataViewController.m
//  SecurityCamera
//
//  Created by Karol Czaradzki on 09/10/14.
//  Copyright (c) 2014 Karol Czaradzki. All rights reserved.
//

#import "DataViewController.h"
#import "SimpleImageCell.h"
#import "StorageHelper.h"


@interface DataViewController () {
    UITableView *tableView;
}

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [tableView reloadData];
}


#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [StorageHelper sharedInstance].storedImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Reusing cell if possible
    SimpleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    //Creating new cell otherwise
    if(!cell) {
        cell = [[SimpleImageCell alloc] init];
    }
    
    //Loading data into cell
    [cell loadData:[[StorageHelper sharedInstance].storedImages objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SimpleImageCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoredImage *dataSource = [[StorageHelper sharedInstance].storedImages objectAtIndex:indexPath.row];
    [self presentViewControllerWithData:dataSource];
}

- (void)presentViewControllerWithData:(StoredImage*)dataSource
{
    GalleryViewController *modelViewController = [[GalleryViewController alloc] init];
    [modelViewController loadData:dataSource];
    modelViewController.delegate = self;
    [self presentViewController:modelViewController animated:YES completion:^{
    }];
}

#pragma mark GallerViewControllerDelegate

- (void)galleryViewControllerDidClose:(GalleryViewController*)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)galleryViewController:(GalleryViewController*)controller didRemovedData:(StoredImage*)dataSource
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [[StorageHelper sharedInstance] removeImage:dataSource];
}

@end
