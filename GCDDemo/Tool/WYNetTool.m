//
//  WYNetTool.m
//  WYProject
//
//  Created by lwy1218 on 16/10/21.
//  Copyright © 2016年 lwy1218. All rights reserved.
//

#import "WYNetTool.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

static NSMutableArray *tasks;
@implementation WYNetTool

+ (NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}
+ (AFHTTPSessionManager *)shareAFManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 30;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        
        /*! 设置响应数据的基本了类型 */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
        /*! 设置相应的缓存策略 */
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        //! 设置返回数据为json, 分别设置请求以及相应的序列化器
        //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
        //        [manager.requestSerializer setValue:@"a7c46f4afec0b612886ce63c7a0b5301" forHTTPHeaderField:@"token"];
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.removesKeysWithNullValues = YES;
        // https  参数配置
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy = securityPolicy;
    });
    return manager;
}

/**取消网络请求*/
+ (void)cancelNetwork
{
    [[[self shareAFManager] operationQueue] cancelAllOperations];
    //    [[[AFURLSessionManager manger]operationQueue] cancelAllOperations];
}
+ (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    //    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSURLSessionTask *)GET_UrlString:(NSString *)urlString
                         parameters:(NSDictionary *)params
                            success:(WYResponseSuccess)success
                               fail:(WYResponseFail)fail
{
    if (urlString == nil)
    {
        return nil;
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSURLSessionTask *sessionTask = nil;
    
    sessionTask = [[self shareAFManager] GET:URLString parameters:params  progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /****************************************************/
        // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", (unsigned long)[URLString hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        
        if (success)
        {
            success(responseObject);
        }
        
        [[self tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail)
        {
            fail(error);
        }
        [[self tasks] removeObject:sessionTask];
        
    }];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}


/**
 *  POST请求
 *
 *  @param url     URL
 *  @param params  参数
 *  @param success 请求成功的回调 responseObject
 *  @param fail    失败的回调 Error
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)POST_UrlString:(NSString *)url
                          parameters:(NSDictionary *)params
                             success:(WYResponseSuccess)success
                                fail:(WYResponseFail)fail
{
    if (url == nil)
    {
        return nil;
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    NSURLSessionTask *sessionTask = nil;
    
    
    sessionTask = [[self shareAFManager] POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* ************************************************** */
        // 如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", (unsigned long)[URLString hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        NSData *data = responseObject;
        NSDictionary *responseObjectDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (success)
        {
            success(responseObjectDict);
        }
        [[self tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail)
        {
            fail(error);
        }
        [[self tasks] removeObject:sessionTask];
        
    }];
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;

}



/**
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString    请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)downLoadFileWithOperations:(NSDictionary *)operations
                                    withSavaPath:(NSString *)savePath
                                   withUrlString:(NSString *)urlString
                                withSuccessBlock:(WYResponseSuccess)successBlock
                                withFailureBlock:(WYResponseFail)failureBlock
                            withDownLoadProgress:(WYLoadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionTask *sessionTask = nil;
    
    sessionTask = [[self shareAFManager] downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress)
            {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
            
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (!savePath)
        {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        }
        else
        {
            return [NSURL fileURLWithPath:savePath];
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self tasks] removeObject:sessionTask];
        if (error == nil)
        {
            if (successBlock)
            {
                /*! 返回完整路径 */
                successBlock([filePath path]);
            }
            else
            {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
        }
    }];
    
    /*! 开始启动任务 */
    [sessionTask resume];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}



/**
 *  上传图片
 *
 *  @param urlString    URL
 *  @param parameters   参数
 *  @param image        要上传的图片
 *  @param name         上传图片的文件名
 *  @param successBlock 上传成功之后的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 *  @return  NSURLSessionTask
 */
+ (NSURLSessionTask *)uploadImageWithUrlString:(NSString *)urlString
                                    parameters:(NSDictionary *)parameters
                                     withImage:(UIImage *)image
                                          name:(NSString *)name
                              withSuccessBlock:(WYResponseSuccess)successBlock
                               withFailurBlock:(WYResponseFail)failureBlock
                            withUpLoadProgress:(WYLoadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSURLSessionTask *sessionTask = nil;
    sessionTask = [[self shareAFManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = [self getImageDataWithImage:image];
        /*! 拼接data */
        if (imgData != nil)
        {   // 图片数据不为空才传递
            /**
             * 参数
             * 第一个 要上传的[二进制数据]
             * name:对应网站上[upload.php中]处理文件的[字段"file"]
             * fileName:要保存在服务器上的[文件名]
             * mimeType:上传文件的[mimeType]
             */
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *mineType = @"image/jpeg";
            [formData appendPartWithFileData:imgData name:name fileName:fileName mimeType:mineType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress)
        {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
        [[self tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock)
        {
            failureBlock(error);
        }
        [[self tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask)
    {
        [[self tasks] addObject:sessionTask];
    }
    
    return sessionTask;

}

/**
 *  上传多个图片
 *
 *  @param urlString    URL
 *  @param parameters   参数
 *  @param images       上传的图片数组
 *  @param name         上传图片的文件名
 *  @param successBlock 上传成功之后的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)uploadImagesWithUrlString:(NSString *)urlString
                                     parameters:(NSDictionary *)parameters
                                         images:(NSArray *)images
                                           name:(NSString *)name
                               withSuccessBlock:(WYResponseSuccess)successBlock
                                withFailurBlock:(WYResponseFail)failureBlock
                             withUpLoadProgress:(WYLoadProgress)progress
{
    if (urlString == nil)
    {
        return nil;
    }
    __weak typeof(self)weakSelf = self;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [self strUTF8Encoding:urlString];
    
    NSURLSessionTask *sessionTask = nil;
    sessionTask = [[self shareAFManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*! 出于性能考虑,将上传图片进行压缩 */
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imgData = [self getImageDataWithImage:obj];
            
            /*! 拼接data */
            if (imgData != nil)
            {   // 图片数据不为空才传递 fileName
                //                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
                
                /**
                 * 参数
                 * 第一个 要上传的[二进制数据]
                 * name:对应网站上[upload.php中]处理文件的[字段"file"]
                 * fileName:要保存在服务器上的[文件名]
                 * mimeType:上传文件的[mimeType]
                 */
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                NSString *mineType = @"image/jpeg";
                [formData appendPartWithFileData:imgData name:name fileName:fileName mimeType:mineType];
            }
            
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        if (progress)
        {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传图片成功 = %@",responseObject);
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
        [[weakSelf tasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failureBlock)
        {
            failureBlock(error);
        }
        [[weakSelf tasks] removeObject:sessionTask];
    }];
    
    if (sessionTask)
    {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;

}

+ (NSMutableURLRequest *)uploadImage:(NSString*)url uploadImage:(UIImage *)uploadImage params:(NSMutableDictionary *)params {
    //方法来源:http://blog.csdn.net/hx_lei/article/details/52054226
    
    //    [params setObject:uploadImage forKey:@"file"];
    NSString *fileName = @"fileName";
    [params setObject:uploadImage forKey:fileName];
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:fileName];
    //得到图片的data
    NSData *imgData = UIImageJPEGRepresentation(image, 0.8);
    //    NSData* data = UIImagePNGRepresentation(image);
    NSData* data = imgData;
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i = 0; i < [keys count]; i++)
    {
        //得到当前key
        NSString *key = [keys objectAtIndex:i];
        //如果key不是file，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:fileName])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明file字段，文件名为image.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc] initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [[self shareAFManager] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"----------------  uploadProgress: %@", uploadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"----------------  Error: %@", error);
        } else {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"--------success-    responseObject -- %@", responseObject);
            NSLog(@"--------dataDict-    dataDict -- %@", dataDict);
        }
    }];
    [uploadTask resume];
    return request;
    /*----------  也可以用下面的方法  ---------------------*/
    /*
     AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     
     NSURLSessionUploadTask *uploadTask;
     
     uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
     if (error) {
     NSLog(@"----------------  Error: %@", error);
     } else {
     NSLog(@"--------success-----  %@ responseObject -- %@", response, responseObject);
     }
     NSData *data = responseObject;
     NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"string === -----  %@ dataDict -- %@", str, dataDict);
     }];
     
     
     [uploadTask resume];
     
     return request;
     */

}

/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */
+ (void)uploadVideoWithUrlString:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                       VideoPath:(NSString *)videoPath
                    SuccessBlock:(WYResponseSuccess)successBlock
                    FailureBlock:(WYResponseFail)failureBlock
                  UploadProgress:(WYLoadProgress)progress
{
    /*! 获得视频资源 */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoPath]  options:nil];
    
    /*! 压缩 */
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    /*! 创建日期格式化器 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /*! 转化后直接写入Library---caches */
    NSString *videoWritePath = [NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:[NSDate date]]];
    NSString *outfilePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", videoWritePath];
    
    AVAssetExportSession *avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    avAssetExport.outputURL = [NSURL fileURLWithPath:outfilePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [[self shareAFManager] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    NSURL *filePathURL2 = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", outfilePath]];
                    // 获得沙盒中的视频内容
                    [formData appendPartWithFileURL:filePathURL2 name:@"video" fileName:outfilePath mimeType:@"application/octet-stream" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                    if (progress)
                    {
                        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    NSLog(@"上传视频成功 = %@",responseObject);
                    if (successBlock)
                    {
                        successBlock(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"上传视频失败 = %@", error);
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];

}



#pragma mark - 私有方法
+ (NSData *)getImageDataWithImage:(UIImage *)obj
{
    
    /*! image的压缩方法 */
    UIImage *resizedImage;
    /*! 此处是使用原生系统相册 */
    if([obj isKindOfClass:[ALAsset class]])
    {
        ALAsset *asset = (ALAsset *)obj;
        // 用ALAsset获取Asset URL  转化为image
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        
        CGImageRef imgRef = [assetRep fullResolutionImage];
        resizedImage = [UIImage imageWithCGImage:imgRef
                                           scale:1.0
                                     orientation:(UIImageOrientation)assetRep.orientation];
        //                imageWithImage
        
        resizedImage = [self imageWithImage:resizedImage scaledToSize:resizedImage.size];
    }
    else
    {
        /*! 此处是使用其他第三方相册，可以自由定制压缩方法 */
        resizedImage = obj;
    }
    
    /*! 此处压缩方法是jpeg格式是原图大小的0.8倍，要调整大小的话，就在这里调整就行了还是原图等比压缩 */
    NSData *imgData = UIImageJPEGRepresentation(resizedImage, 0.8);
    
    return imgData;
}



/**对图片尺寸进行压缩*/
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if (newSize.height > 375/newSize.width*newSize.height)
    {
        newSize.height = 375/newSize.width*newSize.height;
    }
    
    if (newSize.width > 375)
    {
        newSize.width = 375;
    }
    
    //    UIImage *newImage = [UIImage needCenterImage:image size:newSize scale:1.0];
    
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    //    return newImage;
    
    return newImage;
}

@end
