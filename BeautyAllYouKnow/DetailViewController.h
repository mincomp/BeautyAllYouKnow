//
//  DetailViewController.h
//  BeautyAllYouKnow
//
//  Created by Yunfeng Bai on 7/3/15.
//  Copyright (c) 2015 Summer Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSItem;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) RSSItem *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

