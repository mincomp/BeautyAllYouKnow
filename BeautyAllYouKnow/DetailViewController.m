//
//  DetailViewController.m
//  BeautyAllYouKnow
//
//  Created by Yunfeng Bai on 7/3/15.
//  Copyright (c) 2015 Summer Studio. All rights reserved.
//

#import "DetailViewController.h"
#import "RSSItem.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(RSSItem *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    UIWebView *view = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url = [NSURL URLWithString:self.detailItem.fields[@"link"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [view loadRequest:request];
    [self.view addSubview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
