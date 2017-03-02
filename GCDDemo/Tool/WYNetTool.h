//
//  WYNetTool.h
//  WYProject
//
//  Created by lwy1218 on 16/10/21.
//  Copyright © 2016年 lwy1218. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*请求成功的block */
typedef void( ^ WYResponseSuccess)(id responseObject);
/*请求失败的block */
typedef void( ^ WYResponseFail)(NSError *error);
/*下载进度block */
typedef void( ^ WYLoadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);
@interface WYNetTool : NSObject


/**
*  GET请求
*
*  @param urlString URL
*  @param params    参数
*  @param success   请求成功的回调 responseObject
*  @param fail      失败的回调 Error
*
*  @return NSURLSessionTask
*/
+ (NSURLSessionTask *)GET_UrlString:(NSString *)urlString
         parameters:(NSDictionary *)params
            success:(WYResponseSuccess)success
               fail:(WYResponseFail)fail;

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
                fail:(WYResponseFail)fail;

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
                            withDownLoadProgress:(WYLoadProgress)progress;



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
                            withUpLoadProgress:(WYLoadProgress)progress;



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
                            withUpLoadProgress:(WYLoadProgress)progress;


/**将图片封装在Http的请求报文中的请求体（body）中上传*/
+ (NSMutableURLRequest *)uploadImage:(NSString*)url uploadImage:(UIImage *)uploadImage params:(NSMutableDictionary *)params;



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
                     UploadProgress:(WYLoadProgress)progress;

/**取消网络请求*/
+ (void)cancelNetwork;
@end
