//
//  HTTPRequest.m
//  YLHospital_2.0
//
//  Created by 博睿精实 on 15/12/10.
//  Copyright © 2015年 博睿精实. All rights reserved.
//

#import "HTTPRequest.h"

static BOOL netAvailable;

@interface HTTPRequest ()
@property(nonatomic,retain) AFHTTPSessionManager *session;

@end
@implementation HTTPRequest

+ (HTTPRequest *)instance
{
    static HTTPRequest *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer.timeoutInterval = 30;
        _session.responseSerializer = [AFJSONResponseSerializer serializer];
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        _session.securityPolicy.allowInvalidCertificates = YES;
        _session.securityPolicy.validatesDomainName = NO;
    }
    return self;
}

-(void)PostRequestWithURL:(NSString*)url Parameter:(NSDictionary*)parameter succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure netWork:(noNetWord)netWork{
    if ([self isConnectionAvailable]) {

        netWork(YES);
        
        
        [self.session POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            检查token
            NSString* code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                           
            dispatch_async(dispatch_get_main_queue(), ^{
                success(task, responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
        
        
    }else{
        netWork(NO);
    }
}

-(void)sendImageByPth:(UIImage*)image URL:(NSString*)url parameters:(NSDictionary*)params succeed:(void (^)(NSURLSessionDataTask *task, id responseObject))success failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failure netWork:(noNetWord)netWork{
    
    if ([self isConnectionAvailable]) {
        netWork(YES);
        NSMutableDictionary *mparams = [[NSMutableDictionary alloc] initWithDictionary:params];
        NSData* data = UIImageJPEGRepresentation(image, 1.0);

        [self.session POST:url parameters:mparams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (formData != NULL) {
                [formData appendPartWithFileData:data name:@"file" fileName:@"1.png" mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
    }else{
        netWork(NO);
    }
}

- (BOOL)isConnectionAvailable{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                netAvailable = YES;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"Net" object:@{@"net":@"1"}];
                netAvailable = NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                netAvailable = NO;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Net" object:@{@"net":@"0"}];
            }
                break;
            default:
                break;
        }
    }];
    return !netAvailable;
}
@end
