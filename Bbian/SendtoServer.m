//
//  SendtoServer.m
//  Bbian
//
//  Created by dengwt on 2017/3/16.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "SendtoServer.h"
#import "Networking/Networking.h"
#import "AFNetworking/AFNetworking.h"
@implementation SendtoServer
+(BOOL)sendMessage:(UIImage *)image title:(NSString *)title describe:(NSString *)describe url:(NSString *)url location:(CLLocation*)location{
    
    
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    //设置可接受的数据类型
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //开始上传
    //用一个变量去接受结果分析结果然后返回yes or no
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>_Nonnull FormData) {
        //插入图片
        NSData *data=UIImageJPEGRepresentation(image, 1.0);
        NSData *des=[describe dataUsingEncoding:NSUTF8StringEncoding];
        CLLocationCoordinate2D coordinate=location.coordinate;
        
        NSData *latitude=[[NSString stringWithFormat:@"%f",coordinate.latitude]dataUsingEncoding:NSUTF8StringEncoding];
        NSData *longitude=[[NSString stringWithFormat:@"%f",coordinate.longitude]dataUsingEncoding:NSUTF8StringEncoding];
        [FormData appendPartWithFileData:data name:title fileName:[NSString stringWithFormat:@"%@.jpg",title] mimeType:@"image/jpeg"];
        [FormData appendPartWithFormData:des name:title];
        [FormData appendPartWithFormData:latitude name:@"latitude"];
        [FormData appendPartWithFormData:longitude name:@"longitude"];
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功！！");
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"上传失败，%@",error);
        
    }];
    return YES;
}
@end
