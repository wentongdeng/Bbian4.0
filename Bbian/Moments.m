//
//  Moments.m
//  SoolyMomentCell
//
//  Created by SoolyChristina on 2016/11/25.
//  Copyright © 2016年 SoolyChristina. All rights reserved.
//

#import "Moments.h"

@implementation Moments
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)initWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

+(NSMutableArray *)moments:(NSString*)url{
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"Moments.plist" ofType:nil];
    //NSArray *dicArr = [NSArray arrayWithContentsOfFile:path];
    //应该判断一下获取出来的array是否符合要求，是否为空等等
    NSArray *dicArray=[[[ReceivefromServer alloc]init]reveicefromServer:url];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        Moments *moment = [Moments initWithDic:dic];
        [arr addObject:moment];
    }
    return arr;
}


@end
