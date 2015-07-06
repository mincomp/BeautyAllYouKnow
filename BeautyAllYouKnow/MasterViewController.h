//
//  MasterViewController.h
//  BeautyAllYouKnow
//
//  Created by Yunfeng Bai on 7/3/15.
//  Copyright (c) 2015 Summer Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

