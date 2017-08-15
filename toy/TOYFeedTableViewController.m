//
//  TOYFeedTableViewController.m
//  toy
//
//  Created by LuLouie on 2017/5/22.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYFeedTableViewController.h"
#import <AFNetworking.h>


static NSInteger const kPageSize = 15;
static NSString * const kCellIdentifier = @"cellIdentifier";
static NSString * const kBaseUrl = @"http://coolcodeapi.wodetiku.com";


@interface TOYFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) NSMutableArray *feedSource;
@property (nonatomic, assign) NSUInteger pageLoaded;
@property (nonatomic, strong) UIRefreshControl *lodeMoreControl;

@end

@implementation TOYFeedTableViewController

- (instancetype)initWithTitle:(NSString *)title {
  self = [super init];
  if (self) {
    self.title = title;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.clearsSelectionOnViewWillAppear = YES;
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  
  // refresh control
  self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
  [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
  [self.tableView.tableHeaderView addSubview:self.refreshControl];
  self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];

  
  //footer refresh control
//  self.lodeMoreControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
//  [self.lodeMoreControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
//  [self.tableView.tableFooterView addSubview:self.lodeMoreControl];
//  self.lodeMoreControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"上拉加载"];
  
  
  // set local data
  self.feedSource = [NSMutableArray array];
  self.feed = [NSMutableArray array];
  if ([self.title isEqualToString: @"feedWithLocalData"]) {
    for (int i=1; i<=100; i++) {
      NSNumber *num = [NSNumber numberWithInteger:i];
      [self.feedSource addObject:num];
    }
  }
  [self reload];
}

- (NSArray *)fetchLocalDataWithSinceID:(NSInteger)sinceID pageSize:(NSInteger)size {
  //  需要判断 range 越界！
  return [self.feedSource subarrayWithRange:NSMakeRange(sinceID-1, size)];
}

- (void)reload {
  if ([self.title isEqualToString: @"feedWithLocalData"]) {
    NSUInteger sinceID = 1;
    [self.feed removeAllObjects];
    [self.feed addObjectsFromArray: [self fetchLocalDataWithSinceID:sinceID pageSize:kPageSize]];
    if ([self.feed count] > self.pageLoaded) {
      self.pageLoaded = [self.feed count];
    }
  }
  if ([self.title isEqualToString:@"feed from cool code"]) {
    NSDictionary *param = @{
                            @"article_id" : @1,
                            @"page_size" : @5,
                            @"token" : @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vY29vbGNvZGVhcGkud29kZXRpa3UuY29tL2xvZ2luL21vYmlsZSIsImlhdCI6MTQ5NTIwMTc3NiwiZXhwIjoxNDk4NjA5Nzc2LCJuYmYiOjE0OTUyMDE3NzYsImp0aSI6Ill2bW1BVTlnaEdmN2I3THciLCJzdWIiOjQ0fQ.LK6SE9_a9lPuioU6Gr6RT0h611f86r_mFyg1fu30GE8"
                            };
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    NSURLRequest *getRequest = [[AFJSONRequestSerializer serializer]requestWithMethod:@"get" URLString:@"http://coolcodeapi.wodetiku.com/articles/:article_id/comments" parameters:param error:nil];
    
    NSLog(@"%@",getRequest);
    
    [sessionManager GET:@"/articles/:article_id/comments" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (responseObject) {
        NSLog(@"%@\n%@",[responseObject class],responseObject);
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (error) {
        NSLog(@"%@",error);
      }
    }];

    NSURLSessionDataTask *task = [sessionManager dataTaskWithRequest:getRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
      if (response) {
        NSLog(@"%@",response);
      }
      if (responseObject) {
        NSLog(@"%@\n%@",[responseObject class],responseObject);
      }
      if (error) {
        NSLog(@"%@",error);
      }
    }];
    //[task resume];
  }
  
  
  [self.tableView reloadData];
  [self.refreshControl endRefreshing];
}


- (void)loadMore {
  if ([self.title isEqualToString: @"feedWithLocalData"]) {
    NSUInteger sinceID = self.pageLoaded + 1;
    [self.feed addObjectsFromArray: [self fetchLocalDataWithSinceID:sinceID pageSize:kPageSize]];
    if ([self.feed count] > self.pageLoaded) {
      self.pageLoaded = [self.feed count];
    }
  }
  [self.tableView reloadData];
  //[self.lodeMoreControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (/* DISABLES CODE */ (1)||![self.lodeMoreControl isRefreshing]) {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat tableViewLayoutSize = [[UIScreen mainScreen] bounds].size.height - self.topLayoutGuide.length;
    if (offset > self.tableView.contentSize.height - tableViewLayoutSize) {
      //[self.lodeMoreControl beginRefreshing];
      [self loadMore];
      
    }
  }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.feed count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

   NSString *index = [NSString stringWithFormat:@"%@  -  ",[self.feed[indexPath.row] stringValue]];
   cell.textLabel.text = [index stringByAppendingString: [NSDateFormatter  localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]];
 
 return cell;
 }

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
