//
//  ReceivefromServer.m
//  Bbian
//
//  Created by dengwt on 2017/3/24.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import "ReceivefromServer.h"

@implementation ReceivefromServer
@synthesize resultArray;
- (NSArray *)reveicefromServer:(NSString*)url{
    
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    //设置可接受的数据类型
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //开始上传
    //用一个变量去接受结果分析结果然后返回yes or no
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>_Nonnull FormData) {
        //插入图片
        
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"接收成功！！");
            NSArray *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultArray: %@", result);
            self.resultArray=result;
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"接收失败，%@",error);
        
    }];
    return resultArray;
}
@end
