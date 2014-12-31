//
//  ViewController.h
//  NetWorkTest
//
//  Created by wangsl-iMac on 14/12/31.
//  Copyright (c) 2014年 chengtz-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (IBAction)BtnAsynGetClick:(id)sender;
- (IBAction)BtnAsynPostClick:(id)sender;


@end

