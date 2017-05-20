//
//  TOYSignupViewController.m
//  toy
//
//  Created by LuLouie on 2017/5/20.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYSignupViewController.h"
#import <Masonry.h>

static NSString * const kMobileNumber = @"13149829762";


@interface TOYSignupViewController ()

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextView *textView;

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


@end
