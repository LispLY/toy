//
//  TOYAFIPPOSTViewController.m
//  toy
//
//  Created by LuLouie on 2017/8/14.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYAFIPPOSTViewController.h"
#import <AFNetworking.h>
#import <YYKit.h>
#import <NSObject+YYModel.h>

#import "GLBannerInfo.h"

static NSString * const kBaseIpUrl = @"http://192.168.0.222";
static NSString * const kBannerUrl = @"/gl/user/homePage/getBannerInfo.do";


@interface TOYAFIPPOSTViewController ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) id jsonModel;

@end

@implementation TOYAFIPPOSTViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.label = [UILabel new];
  self.label.center = self.view.center;
  [self.label setFrame:self.view.bounds];
  self.label.numberOfLines = 0;
  [self.view addSubview:self.label];
  [self sendRequest];
}
- (void)sendRequest {
  NSURL *baseUrl = [NSURL URLWithString:kBaseIpUrl];
  NSURL *url = [NSURL URLWithString:kBannerUrl relativeToURL:baseUrl];
  
  NSDictionary *param = @{};
  
  AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
  
  
  NSURLRequest *request = [serializer requestWithMethod:@"POST" URLString:[url absoluteString] parameters:param error:nil];
  
  AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
  
  __weak typeof (self)weakself = self;
  
  NSURLSessionTask *task = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    NSLog(@"first:%@\n",response);
    if(error) {
      NSLog(@"error:%@\n",error);
    } else {
      NSLog(@"responseObject:%@",responseObject);
      
      NSLog(@"responseObject class:%@",[responseObject class]);
      
      self.jsonModel = responseObject;
      GLBannerInfo *info = [GLBannerInfo modelWithJSON:self.jsonModel];
      NSLog(@"%@",info);
      NSLog(@"%ld",info.code);
      NSLog(@"%@",info.data);
      NSLog(@"%@",info.data.class);
      NSLog(@"%@",info.data[0]);

      NSLog(@"%@",info.data[0].class);
      NSLog(@"%@",info.data[0][@"bannerImg"]);
      NSLog(@"%@",[info.data[0][@"bannerImg"] class ]);


      dispatch_async(dispatch_get_main_queue(), ^{
        weakself.label.text = [NSString stringWithFormat:@"%@\n",responseObject];
      });
    }
    
  }];
  
  
  [task resume];
  NSLog(@"ok?");
  
}


@end
