//
//  TOYSignupViewController.m
//  toy
//
//  Created by LuLouie on 2017/5/20.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYSignupViewController.h"
#import <Masonry.h>


@interface TOYSignupViewController ()

@end

@implementation TOYSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupViews];
}

- (void)setupViews {
  self.sendButton = [[UIButton alloc] init];
  [self.sendButton setTitle:[NSString stringWithFormat:@"请求验证码 电话号码：%@",kMobileNumber] forState:UIControlStateNormal];
  [self.sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [self.sendButton addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
  
  self.textView = [[UITextView alloc] init];
  
  [self.view addSubview:self.sendButton];
  [self.view addSubview:self.textView];
  
  UIView *superView = self.view;
  [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
    make.centerX.equalTo(superView.mas_centerX);
  }];
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.sendButton.mas_bottom).offset(40);
    make.width.equalTo(superView);
    make.bottom.equalTo(superView.mas_bottom);
  }];
}

- (void)sendRequest {
  NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
  NSURL *url = [NSURL URLWithString:kSignupUrl relativeToURL:baseUrl];
  
  NSDictionary *param = @{@"mobile":@"13149829762"};
  [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
  
  
  NSURL *urlWithParam = [NSURL URLWithString:@"?mobile=13149829762" relativeToURL:url];
  
  
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlWithParam];
  request.HTTPMethod = @"POST";
//  NSData *paramData = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//  NSString *paramString = [[NSString alloc] initWithData:paramData encoding:NSASCIIStringEncoding];
//  NSData *bodyData = [paramString dataUsingEncoding:NSASCIIStringEncoding];
//  [request setHTTPBody:bodyData];
// 
//  
//  NSLog(@"%@",paramString);
//  NSLog(@"%@",bodyData);
//  NSLog(@"%@",request);
//  NSLog(@"%@",request.HTTPBody);

  
  __weak typeof (self)weakself = self;
  
  NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"%@",response);
    if(error) {
      NSLog(@"%@",error);
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      weakself.textView.text = [NSString stringWithFormat:@"%@\n%@",dict,response];
    });
    
  }];
  
  [task resume];
  NSLog(@"ok?");
  NSLog(@"%@",urlWithParam);
  
}



@end






