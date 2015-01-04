//
//  NFNetWorkViewController.m
//  NetWorkTest
//
//  Created by cheng on 15/1/3.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import "NFNetWorkViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface NFNetWorkViewController ()

@end

@implementation NFNetWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)ParseDataFromJson:(NSDictionary *)Data{
    NSDictionary * dicRoot = [Data valueForKey:@"weatherinfo"];
    if (dicRoot != nil) {
        NSString * city = [dicRoot valueForKey:@"city"];
        NSString * cityID = [dicRoot valueForKey:@"cityid"];
        NSString * temp = [dicRoot valueForKey:@"temp"];
        
        NSLog(@"城市:%@, 温度:%@", city, temp);
    }
}

- (IBAction)GetWithOutPrama:(id)sender {
        NSString *str=[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/101010100.html"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperationManager * opearManager = [AFHTTPRequestOperationManager manager];
        opearManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
        [opearManager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html  = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            NSLog(@"获取到的数据为：%@",dict);
            
            [self ParseDataFromJson:dict];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
    
        }];
}

- (IBAction)GetWithPramas:(id)sender {
    
    
    NSString *str=[NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php"];
    NSDictionary * params1 = @{@"w":@"swift", @"key":@"30CBA9DDD34B16DB669A9B214C941F14",@"type":@"json"};
    AFHTTPRequestOperationManager * Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [Manager GET:str parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html  = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        
    }];

    
}
@end
