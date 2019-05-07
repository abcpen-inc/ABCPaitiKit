//
//  AppDelegate.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/3/18.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <ABCPaitiKit/ABCPaitiKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate ()<ABCPaitiAuthDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ABCPaitiManager sharedInstance].delegate = self;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) refreshNewToken:(void (^)(NSString *token))success
                failure:(void (^)(NSString *msg))fail
{
     @synchronized(self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *token = [self getToken];
            if (token.length > 0) {
                success(token);
            }else{
                fail(@"");
            }
        });
    }
}

- (NSString *) md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(NSString *) getToken
{
    NSString *appId = @"afd27998ad764d";
    NSString *appSecret = @"6eb73f1419e84a31b8a7d7f44e815d63";
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    //调用app自身的服务器获取连接im服务必须的access token
    NSString *signStr = [NSString stringWithFormat:@"%@%lld%@",appId,timestamp,appSecret];
    NSString *sign = [[self md5:signStr] lowercaseString];
    NSString *url = [NSString stringWithFormat:@"https://openapi.abcpen.com/api/auth/token?appId=%@&timestamp=%lld&sign=%@&expiration=%d",appId,timestamp,sign,3600];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"error:%@", error);
        return nil;
    }
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
    if (httpResp.statusCode != 200) {
        return nil;
    }
    NSDictionary *e = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return [[e objectForKey:@"data"] objectForKey:@"accessToken"];
}


@end
