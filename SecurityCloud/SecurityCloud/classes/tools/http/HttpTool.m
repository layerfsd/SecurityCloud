//
//  HttpTool.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool
+ (void)get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton sharedHttpSessionManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
    
+ (void)post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton sharedHttpSessionManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
       
        
}

+ (void)post:(NSString *)URLString
  parameters:(id)parameters
       image:(UIImage*)image
   imageName:(NSString*)imageName
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton sharedHttpSessionManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image,0.5);//把要上传的图片转成NSData
        NSString *fileName = [NSString stringWithFormat:@"%@.png", imageName];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
         
     
         /*
         @“video/quicktime” 视频流
         
         */

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
   
}

+ (void)post:(NSString *)URLString
  parameters:(id)parameters
       voice:(NSData*)voice
   voiceName:(NSString*)voiceName
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton sharedHttpSessionManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
        NSString *fileName = [NSString stringWithFormat:@"%@.wav", voiceName];
        
        [formData appendPartWithFileData:voice name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        
        
        
        /*
         @“video/quicktime” 视频流
         
         */
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
@implementation AFHTTPSessionSingleton
    
static AFHTTPSessionManager *manager;
    
+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}
    
@end

