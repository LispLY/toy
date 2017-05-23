//
//  TOYMainTableViewController.m
//  toy
//
//  Created by LuLouie on 2017/5/20.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYMainTableViewController.h"
#import "TOYExampleViewController.h"
#import "TOYSignupViewController.h"
#import "TOYAFSignupViewController.h"
#import "TOYFeedTableViewController.h"

static NSString * const kCellReuseIdentifier = @"cellReuseIdentifier";

@interface TOYMainTableViewController ()

@property (nonatomic, strong) NSArray *controllers; // of TOYExampleViewControllers

@end

@implementation TOYMainTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.controllers = @[
                       [[TOYSignupViewController alloc] initWithTitle:@"sign up"],
                       [[TOYExampleViewController alloc] initWithTitle:@"sign in"],
                       [[TOYFeedTableViewController alloc] initWithTitle:@"feedWithLocalData"],
                       [[TOYExampleViewController alloc] initWithTitle:@"main what"],
                       [[TOYAFSignupViewController alloc] initWithTitle:@"sign up with AFNetworking"]
                       ];
  
  self.title = @"Have Fun!";
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
  self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
  cell.textLabel.text = ((UIViewController *) self.controllers[indexPath.row]).title;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.navigationController pushViewController:self.controllers[indexPath.row] animated:YES];
}

@end
