//
//  ViewController.m
//  NetWorkTest
//
//  Created by wangsl-iMac on 14/12/31.
//  Copyright (c) 2014年 chengtz-iMac. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()
{

}

@property(nonatomic, strong)NSMutableData *loadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.loadData = [NSMutableData new];
    
//    NSString *str=[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/101010100.html"];
//    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *html = operation.responseString;
//        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"获取到的数据为：%@",dict);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"发生错误！%@",error);
//    }];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];
    
    
    
//    NSString * strUrl = @"http://dict-co.iciba.com/api/dictionary.php";//@"http://dict-co.iciba.com/api/dictionary.php";
//    AFHTTPRequestOperationManager *requestPost = [AFHTTPRequestOperationManager manager];
//    NSDictionary * params1 = @{@"w":@"swift", @"key":@"30CBA9DDD34B16DB669A9B214C941F14",@"type":@"json"};
//    
////    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
////                            @"swift",@"w",
////                            @"30CBA9DDD34B16DB669A9B214C941F14",@"key",
////                            @"json",@"type",
////                            nil];
//    
//    requestPost.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
//    
//    [requestPost POST:strUrl parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *html  = operation.responseString;
//        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"获取到的数据为：%@",dict);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"发生错误！%@",error);
//    }];

////请求金山词霸API获取单词`swift`的解释
//http://dict-co.iciba.com/api/dictionary.php?w=swift&key=30CBA9DDD34B16DB669A9B214C941F14&type=json
    
    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BtnAsynGetClick:(id)sender {
    
    //@"http://m.weather.com.cn/data/101010100.html"

    NSString * postUrl = @"http://www.weather.com.cn/data/sk/101010100.html";
    NSString * strUrl = [[NSString alloc]initWithString:postUrl];
    
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLConnection * conntection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (IBAction)BtnAsynPostClick:(id)sender {
    
    NSError *error;
    //    加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101010100.html"]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
    
    NSLog(@"今天是 %@ %@ %@ 的天气状况是:%@ %@",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"],[weatherInfo objectForKey:@"weather1"],[weatherInfo objectForKey:@"temp1"]);
    //    打印出weatherInfo字典所存储数据
    NSLog(@"weatherInfo字典里面的内容是--->%@",[weatherInfo description]);
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.loadData appendData:data];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    
    NSError * error = [[NSError alloc]init];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:self.loadData options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary * weatherInfo = [weatherDic valueForKey:@"weatherinfo"];
    NSString * city = [weatherInfo valueForKey:@"city"];
    
}

@end
