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
{
    NSURLSessionDownloadTask *downloadTask;
    AFURLSessionManager *manager;
    NSData * resumeDataTmp;
}
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
    NSString * strFull = @"https://itunes.apple.com/search?country=TW&term=wangfei";
    NSString *str=[NSString stringWithFormat:@"https://itunes.apple.com/search/"];
    NSDictionary * params1 = @{ @"country" :@"TW",@"term" : @"wangfei" };
    AFHTTPRequestOperationManager * Manager = [AFHTTPRequestOperationManager manager];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [Manager GET:strFull parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                NSLog(@"歌手名称:%@,\r\n 图片URL:%@,\r\n 专辑名:%@,\r\n  歌曲名:%@,\r\n  歌曲URL:%@,\r\n", name, pic_100, collectionCensoredName, trackCensoredNam, previewUrl);
            }
        
    }];
}
//http://a196.phobos.apple.com/us/r2000/009/Music/v4/4d/e7/74/4de7747f-4e7d-03e3-a51d-79fc7ee3b791/mzaf_6317458006875106910.aac.m4a

//http://a2.mzstatic.com/us/r30/Music/8d/5e/b3/mzi.bjvemxnq.100x100-75.jpg

//file:///Users/kong/Library/Developer/CoreSimulator/Devices/2D14F0D3-228D-48EA-B306-858B1426DFD3/data/Containers/Data/Application/9F016010-5D08-4D0D-B6CB-79E577E43FB7/tmp/CFNetworkDownload_4bRFKQ.tmp

//file:///Users/kong/Library/Developer/CoreSimulator/Devices/2D14F0D3-228D-48EA-B306-858B1426DFD3/data/Containers/Data/Application/317B1AF7-5CD9-4DE3-A0B8-B61D7B2D1018/Documents/mzi.bjvemxnq.100x100-75.jpg
- (IBAction)DownLoad:(id)sender {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://a196.phobos.apple.com/us/r2000/009/Music/v4/4d/e7/74/4de7747f-4e7d-03e3-a51d-79fc7ee3b791/mzaf_6317458006875106910.aac.m4a"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //将一个NSProgress 指针传入，在设置其KVO就可以监测到下载的进度值
    NSProgress * progress = nil;
    downloadTask = [manager downloadTaskWithRequest:request progress:&progress
    destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        //获取当前NSDocumentDirectory目录地址
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    }
    completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
    {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [downloadTask resume];

}

// 监听到了属性改变会调用这个方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        //NSLog(@"progress :%@", change);
        NSString * progress = [change valueForKey:@"new"];
        NSProgress * p = (NSProgress *)object;
        NSLog(@"progress :%@, %@", progress, p.localizedDescription);
    }
}

//file:///Users/kong/Library/Developer/CoreSimulator/Devices/2D14F0D3-228D-48EA-B306-858B1426DFD3/data/Containers/Data/Application/F551A2D4-B744-41EF-96A2-674B1E8E9B0E/Documents/mzaf_6317458006875106910.aac.m4a
- (IBAction)PasueDownLoad:(id)sender {
    
    // 如果下载任务不存在，直接返回
    if (downloadTask == nil) return;
    
    // 暂停任务(块代码中的resumeData就是当前正在下载的二进制数据)
    // 停止下载任务时，需要保存数据
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        resumeDataTmp = resumeData;
        
        // 清空并且释放当前的下载任务
        downloadTask = nil;
    }];
    
    //downloadTaskWithResumeData
}

- (IBAction)ResumDownLoad:(id)sender {
    if (resumeDataTmp == nil) {
        return;
    }
    
    //将一个NSProgress 指针传入，在设置其KVO就可以监测到下载的进度值
    NSProgress * progress = nil;
    downloadTask = [manager downloadTaskWithResumeData:resumeDataTmp progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //获取当前NSDocumentDirectory目录地址
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    [downloadTask resume];
}


- (IBAction)UpLoad:(id)sender {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

@end
