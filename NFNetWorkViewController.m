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
#import "AFHTTPSessionManager.h"
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

- (IBAction)GetITunesList:(id)sender {
    NSURL *baseURL = [NSURL URLWithString:@"https://itunes.apple.com/"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
    
    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    
    [config setURLCache:cache];
    
    AFHTTPSessionManager *sessinMag = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL sessionConfiguration:config];
    
    sessinMag.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *task = [sessinMag GET:@"/search" parameters:@{ @"country" :@"TW",@"term" : @"wangfei" } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (httpResponse.statusCode == 200) {
            NSLog(@"httpResponse: statusCode = 200");
            NSArray * result = responseObject[@"results"];
            
            //NSLog(@"Data :%@", result);
            for (NSUInteger index = 0; index <= result.count - 1; index++) {
                
                NSString * name = [self PraseData:result[index] Key:@"artistName"];
                NSString * pic_100 = [self PraseData:result[index] Key:@"artworkUrl100"];
                NSString * collectionCensoredName = [self PraseData:result[index] Key:@"collectionCensoredName"];
                NSString * collectionName = [self PraseData:result[index] Key:@"collectionName"];
                NSString * trackCensoredNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * trackNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * previewUrl = [self PraseData:result[index] Key:@"previewUrl"];
                NSLog(@"歌手名称:%@,\r\n 图片URL%@:,\r\n 专辑名:%@,\r\n  歌曲名:%@,\r\n  歌曲URL:%@,\r\n", name, pic_100, collectionCensoredName, trackCensoredNam, previewUrl);
            }
            
        } else {
            
            
            NSLog(@"Received: %@", responseObject);
            NSLog(@"Received HTTP %ld", httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error :%@", error);
    }];

}

-(NSString *)PraseData:(NSDictionary * )indexDic Key:(NSString *)key{
    
    return indexDic[key];
}

- (IBAction)GetiTunesListWithGet:(id)sender {
    NSString *str=[NSString stringWithFormat:@"https://itunes.apple.com/search/"];
    NSDictionary * params1 = @{ @"country" :@"TW",@"term" : @"wangfei" };
    AFHTTPRequestOperationManager * Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [Manager POST:str parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html  = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        NSLog(@"Data :%ld UserInfo:%@", error.code, error.userInfo);
        //if (error.code == 200) {

        NSString *html  = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray * result = dict[@"results"];
        if (result == nil) {
            return ;
        }
        
            for (NSUInteger index = 0;  index <= result.count - 1; index++) {
                
                NSString * name = [self PraseData:result[index] Key:@"artistName"];
                NSString * pic_100 = [self PraseData:result[index] Key:@"artworkUrl100"];
                NSString * collectionCensoredName = [self PraseData:result[index] Key:@"collectionCensoredName"];
                NSString * collectionName = [self PraseData:result[index] Key:@"collectionName"];
                NSString * trackCensoredNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * trackNam = [self PraseData:result[index] Key:@"trackCensoredName"];
                NSString * previewUrl = [self PraseData:result[index] Key:@"previewUrl"];
                NSLog(@"歌手名称:%@,\r\n 图片URL:%@:,\r\n 专辑名:%@,\r\n  歌曲名:%@,\r\n  歌曲URL:%@,\r\n", name, pic_100, collectionCensoredName, trackCensoredNam, previewUrl);
            }
        
    }];
}

@end
