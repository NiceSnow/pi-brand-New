//
//  HTTPRequest.h
//  YLHospital_2.0
//
//  Created by 博睿精实 on 15/12/10.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^noNetWord)(BOOL netWork);

@interface HTTPRequest : NSObject
+ (HTTPRequest *)instance;
- (BOOL)isConnectionAvailable;
-(void)PostRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure netWork:(noNetWord)netWork;
-(void)sendImageByPth:(UIImage*)image URL:(NSString*)url parameters:(NSDictionary*)params succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure netWork:(noNetWord)netWork;
@end
