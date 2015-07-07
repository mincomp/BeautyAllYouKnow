//
//  MasterViewController.m
//  BeautyAllYouKnow
//
//  Created by Yunfeng Bai on 7/3/15.
//  Copyright (c) 2015 Summer Studio. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RSSItem.h"

@interface MasterViewController ()

@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (strong, nonatomic) NSMutableArray *rssItems;
@property (strong, nonatomic) RSSItem *currentItem;
@property (strong, nonatomic) NSString *expectingElement;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *urlStr = @"http://www.beautyallyouknow.com/?feed=rss2";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length] > 0 && error == nil) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            if ([self.xmlParser parse]) {
                NSLog(@"Parsed");
                [self.tableView performSelectorOnMainThread:@selector(reloadData)
                                                 withObject:nil
                                              waitUntilDone:YES];
            } else {
                NSLog(@"Failed to parse the XML");
            }
        } else if ([data length] == 0 && error == nil) {
            NSLog(@"Nothing was downloaded.");
        } else {
            NSLog(@"Error happened = %@", error);
        }
    }];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XML Parser
- (void) parserDidStartDocument:(NSXMLParser *)parser {
    self.currentItem = nil;
    self.expectingElement = nil;
    self.rssItems = [[NSMutableArray alloc] init];
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqual:@"item"]) {
        self.currentItem = [[RSSItem alloc] init];
    } else if (self.currentItem != nil) {
        self.expectingElement = elementName;
    }
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    if (self.currentItem == nil || self.expectingElement == nil) {
        return;
    }
    
    if ([self.currentItem.fields objectForKey:self.expectingElement] == nil) {
        self.currentItem.fields[self.expectingElement] = string;
    } else {
        [self.currentItem.fields[self.expectingElement] stringByAppendingString:string];
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
    if (self.currentItem != nil && [elementName isEqual:@"item"]) {
        [self.rssItems addObject:self.currentItem];
        self.currentItem = nil;
        self.expectingElement = nil;
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *item = self.rssItems[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:item];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rssItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RSSItem *item = self.rssItems[indexPath.row];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.text = item.fields[@"title"];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = item.fields[@"description"];
    
    UIView *view = (UIView *)[cell viewWithTag:3];
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 10;
    view.layer.shadowRadius = 2;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.5;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
