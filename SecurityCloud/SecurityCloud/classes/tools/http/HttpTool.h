//
//  HttpTool.h
//  SecurityShield
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@interface HttpTool : NSObject

+ (void)get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
    
+ (void)post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

+ (void)postWithoutOK:(NSString *)URLString
           parameters:(id)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
+ (void)postWithoutProgress:(NSString *)URLString
                 parameters:(id)parameters
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
//上传图片
+ (void)post:(NSString *)URLString
  parameters:(id)parameters
       image:(UIImage*)image
   imageName:(NSString*)imageName
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;


//上传语音
+ (void)post:(NSString *)URLString
  parameters:(id)parameters
       voice:(NSData*)voice
   voiceName:(NSString*)voiceName
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
@end


@interface AFHTTPSessionSingleton : NSObject
+(AFHTTPSessionManager *)sharedHttpSessionManager;
@end
