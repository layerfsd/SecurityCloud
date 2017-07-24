//
//  HttpTool.m
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "HttpTool.h"
#import "NSString+Utility.h"
#import "Md5Util.h"
#import "DeviceHelper.h"
@implementation HttpTool
+ (void)get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    
    NSMutableDictionary *para = [self postDict:parameters];
    
    
    [manager GET:urlStr parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            success(responseObject);
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        failure(error);
    }];
}
+ (void)getToken:(NSString *)URLString
      parameters:(id)parameters
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure{
//    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    NSMutableDictionary *para = [self postDict:parameters];
    
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
//        if ([responseObject[@"status"] isEqualToString:@"ok"]) {
            success(responseObject);
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        failure(error);
    }];

}
+ (void)post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];

    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    
    NSMutableDictionary *para = [self postDict:parameters];
    
    
    [manager POST:urlStr parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

            success(responseObject);

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        failure(error);
    }];
       
        
}

+ (void)postWithoutOK:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        success(responseObject);
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        failure(error);
    }];
    
    
}
+ (void)postWithoutProgress:(NSString *)URLString
           parameters:(id)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{

    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
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
    [SVProgressHUD showWithStatus:@"提交数据中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
    NSDictionary *param = [self postDict:parameters];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    [manager POST:urlStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image,0.5);//把要上传的图片转成NSData
        NSString *fileName = [NSString stringWithFormat:@"%@.png", imageName];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

            success(responseObject);


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
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
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton customManager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",RootPath,URLString];
    
    NSDictionary *para = [self postDict:parameters];
    
    [manager POST:urlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
        NSString *fileName = [NSString stringWithFormat:@"%@.wav", voiceName];
        
        [formData appendPartWithFileData:voice name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        
        
        
        /*
         @“video/quicktime” 视频流
         
         */
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];

            success(responseObject);


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        failure(error);
    }];
}


+(NSString*)stringWithDict:(NSDictionary*)dict{
    
    NSArray *keys = [dict allKeys];
    
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        
        return[obj1 compare:obj2 options:NSNumericSearch];
        
    }];
    
    NSString *str = @"";
    
    for(NSString *categoryId in sortedArray) {
        
        id value = [dict objectForKey:categoryId];
        
        if([str length] !=0) {
            
            str = [str stringByAppendingString:@"&"];
            
        }
        
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
        
    }
    
    return str;
    
}


+(NSMutableDictionary*)postDict:(NSDictionary*)dict{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString *randomStr = [NSString randomStringWithLength:17];
    [dic setValue:randomStr forKey:@"nonce_str"];
    NSString *sign = [self sign:dict randomStr:randomStr];
    [dic setValue:sign forKey:@"sign"];
    return dic;
}

+(NSString*)sign:(NSDictionary*)dict randomStr:(NSString*)randomStr {
    NSString *str = [self stringWithDict:dict];
    if (str.length != 0) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"&nonce_str=%@",randomStr]];
    }else{
        str = [str stringByAppendingString:[NSString stringWithFormat:@"nonce_str=%@",randomStr]];
    }
    
    NSString *stringSignTemp = [NSString stringWithFormat:@"%@&key=%@",str,@"m855afec7jsa3f02ad0013g6"];
    NSString *md5 = [Md5Util encryptMD5:stringSignTemp];
    NSString *sign = md5.uppercaseString;
    
    return sign;
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

+(AFHTTPSessionManager*) customManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionSingleton sharedHttpSessionManager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[DeviceHelper version] forHTTPHeaderField:@"Version"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Platform"];
    [manager.requestSerializer setValue:[DeviceHelper iphoneType] forHTTPHeaderField:@"DeviceType"];
    return manager;
}
    
@end

