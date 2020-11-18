//
//  ZZImageManager.m
//  ZhuoZhuo
//
//  Created by wisesoft on 2020/11/17.
//  Copyright © 2020 wisesoft. All rights reserved.
//

#define FilePathName @"ZZImageFile"
#import "ZZImageManager.h"
#import "NSString+MD5.h"

typedef NS_ENUM(NSInteger, SDImageFormat) {
    SDImageFormatUndefined = -1,
    SDImageFormatJPEG = 0,
    SDImageFormatPNG,
    SDImageFormatGIF,
    SDImageFormatTIFF,
    SDImageFormatWebP
};
@interface ZZImageManager()< NSCacheDelegate,NSURLSessionDelegate>
//下载队列
@property (nonatomic,strong) NSOperationQueue *downloadQueue;

@property (nonatomic,strong) NSCache  *cache;
@property (nonatomic,strong) NSString *cacheImageHomePath;
@property (nonatomic,strong) NSLock *fileLock;
@property (nonatomic,strong) NSLock *downloadLock;

//正在下载的任务
@property (nonatomic,strong) NSMutableDictionary *taskOpeations;

//队列的最高并发数目
@property (nonatomic,assign) NSInteger maxConcurrenNum;
@end

@implementation ZZImageManager

-(NSLock *)downloadLock{
    if (!_downloadLock) {
        _downloadLock = [[NSLock alloc]init];
    }
    return _downloadLock;
}

-(NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc]init];
        //设置缓存数量 超过20个自动清理
        _cache.countLimit= 20;
    }
    return _cache;
}

-(NSLock *)fileLock{
    if (!_fileLock) {
        _fileLock = [[NSLock alloc]init];
    }
    return _fileLock;
}


//图片存储文件夹
-(NSString *)cacheImageHomePath{
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dataFilePath = [libPath stringByAppendingPathComponent:FilePathName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        // 创建目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dataFilePath;
}


+(BOOL)writeFile{
    return true;
}




+(ZZImageManager *)shareManager{
    static ZZImageManager *manager = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        manager = [[ZZImageManager alloc]init];
        [manager initParams];
    });
    return manager;
}

-(void)initParams{
    //设置默认值 防止同时创建大量线程 消耗内存
    
    self.maxConcurrenNum = 5;
    self.downloadQueue = [[NSOperationQueue alloc]init];
    
}


//下载图片
-(void)ZzManagerDownLoadWithUrl:(NSString *)url andFinishHandlerSucess:(void(^)(UIImage *image))image andError:(void(^)(NSError *error))error{
    
    //读取内存缓存
    UIImage *cacheImg = [self getImageInCacheWithPath:url];
    if (cacheImg) {
        image(cacheImg);
        return;
    }
    
    //读取磁盘存储
    UIImage *libImg = [self getImageInLibWithPath:url];
    if (libImg) {
        image(libImg);
        return;
    }
    
    [self.downloadLock lock];
    [self addTaskWithUrlWithPath:url andSucess:^(UIImage *imageHandler) {
        //回到主线程刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            image(imageHandler);
        });
    } andError:^(NSError *errorHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            error(errorHandler);
        });
    }];
    [self.downloadLock unlock];
    
    //内存和磁盘都没有数据  则下载
    
}



//从内存中读取

-(UIImage *)getImageInCacheWithPath:(NSString *)path{
    if ([self.cache objectForKey:path]) {
        return (UIImage *)[self.cache objectForKey:path];
    }
    return nil;
}

//从磁盘中读取
-(UIImage *)getImageInLibWithPath:(NSString *)path{
    //获取图片存储文件夹
    NSString *homePath = [self cacheImageHomePath];
    NSString *fileName = [path stringToMD5];
    
    //
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    if (image) {
        return image;
    }
    return nil;
}

//写入磁盘
-(void)writeToLibFileWithPath:(NSString *)path andData:(NSData *)data{
    NSString *homePath = [self cacheImageHomePath];
    NSString *fileName = [path stringToMD5];
    //写入文件
    NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:true];

    
}


//开启下载

-(void)addTaskWithUrlWithPath:(NSString *)path andSucess:(void(^)(UIImage *image))sucess andError:(void(^)(NSError *error))error{
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSString *encodePath =  [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet]; //=@"https://suggest.taobao.com/sug?code=utf-8&q=%E5%8D%AB%E8%A1%A3&callback=cb";
       
//
//        NSString *encodePath =[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet
//        URLQueryAllowedCharacterSet]];
        NSURL * url = [NSURL URLWithString:encodePath];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        
#pragma mark post
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];

        request.HTTPMethod = @"GET";
        request.timeoutInterval = 20;
        request.HTTPShouldUsePipelining = YES;
        [request.allHTTPHeaderFields setValue:@"image/jpeg" forKey:@"Content-Type"];

      
        NSURLSessionTask *task =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable failer) {
            if (failer) {
                error(failer);
                return;
            }
            if (data) {
                UIImage *img = [UIImage imageWithData:data scale:1];
                sucess(img);
                //加锁
                if (img) {
                    [self.fileLock lock];
                    [self.cache setObject:img forKey:path];
                    [self writeToLibFileWithPath:path andData:data];
                    [self.fileLock unlock];
                }
                return;
            }
        }];
//
//
//        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable failer) {
//
//            if (error) {
//                error(failer);
//                return;
//            }
//            if (data) {
//                UIImage *img = [UIImage imageWithData:data];
//                sucess(img);
//                //加锁
//                [self.fileLock lock];
//                [self.cache setObject:img forKey:path];
//                [self writeToLibFileWithPath:path andData:data];
//                [self.fileLock unlock];
//                return;
//            }
//        }];
        [task resume];
    }];
    [self.downloadQueue addOperation:op];
}

//主要就是处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
     if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){//服务器信任证书
            
          NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
          if(completionHandler)
             completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
      }
}

- (SDImageFormat)sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return SDImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return SDImageFormatJPEG;
        case 0x89:
            return SDImageFormatPNG;
        case 0x47:
            return SDImageFormatGIF;
        case 0x49:
        case 0x4D:
            return SDImageFormatTIFF;
        case 0x52:
            // R as RIFF for WEBP
            if (data.length < 12) {
                return SDImageFormatUndefined;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return SDImageFormatWebP;
            }
    }
    return SDImageFormatUndefined;
}




//清除磁盘缓存 
-(void)clearDisk{
   
}
//清除内存缓存
-(void)clearCache{
  [self.cache removeAllObjects];
}


@end
