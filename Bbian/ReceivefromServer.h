//
//  ReceivefromServer.h
//  Bbian
//
//  Created by dengwt on 2017/3/24.
//  Copyright © 2017年 dengwt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Networking/Networking.h"
@interface ReceivefromServer : NSObject
@property (strong,nonatomic)NSArray *resultArray;
- (NSArray *)reveicefromServer:(NSString*)url;
@end
