//
//  TOYSignupViewController.h
//  toy
//
//  Created by LuLouie on 2017/5/20.
//  Copyright © 2017年 LuLouie. All rights reserved.
//

#import "TOYExampleViewController.h"

static NSString * const kMobileNumber = @"13149829762";
static NSString * const kBaseUrl = @"http://miaomiaoapi.qijitest.tech";
static NSString * const kSignupUrl = @"/captcha/send/mobile";


@interface TOYSignupViewController : TOYExampleViewController

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextView *textView;

@end
