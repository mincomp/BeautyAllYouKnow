//
//  RSSItem.m
//  BeautyAllYouKnow
//
//  Created by Yunfeng Bai on 7/5/15.
//  Copyright (c) 2015 Summer Studio. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

- (NSMutableDictionary *) fields {
    if (_fields == nil) {
        _fields = [[NSMutableDictionary alloc] init];
    }
    
    return _fields;
}

@end
