//
//  TOYSimpleFeedViewController.m
//  toy
//
//  Created by LuLouie on 2017/5/22.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYSimpleFeedViewController.h"
#import <AFNetworking.h>


@interface TOYSimpleFeedViewController ()

@end

@implementation TOYSimpleFeedViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.sendButton setTitle:@"获取内容" forState:UIControlStateNormal];
}

- (void)sendRequest {
  NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
  NSURL *url = [NSURL URLWithString:kSignupUrl relativeToURL:baseUrl];
  
  NSDictionary *param = @{@"mobile":@"13149829762"};
  
  NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[url absoluteString] parameters:param error:nil];
  
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
  
  __weak typeof (self)weakself = self;
  
  NSURLSessionTask *task = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    NSLog(@"%@",response);
    if(error) {
      NSLog(@"%@",error);
    } else {
      NSLog(@"%@",responseObject);
      
      NSLog(@"%@",[responseObject class]);
      
      dispatch_async(dispatch_get_main_queue(), ^{
        weakself.textView.text = [NSString stringWithFormat:@"%@\n%@",response,responseObject];
      });
    }
    
  }];
  
  
  [task resume];
  NSLog(@"ok?");
  
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
