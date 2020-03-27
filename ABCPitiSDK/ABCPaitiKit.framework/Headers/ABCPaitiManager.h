//
//  ABCPaitiManager.h
//  ABCPaitiKit
//
//  Created by bingo on 2018/4/12.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ABCErrorCode) {
    ABCErrorCode_BUSINESS_ERROR         = 10001, //服务器繁忙，请重试
    ABCErrorCode_EMPTY_TOKEN            = 10005, //token为空
    ABCErrorCode_TOKEN_EXPIRED          = 10006, //token过期
    ABCErrorCode_INVALID_TOKEN          = 10007, //token无效
    ABCErrorCode_SIGN_ILLEGAL           = 10027, //签名不合法
    ABCErrorCode_APP_ID_ILLEGAL         = 10037, //appId不合法
    ABCErrorCode_EXPIRATION_TOO_SHORT   = 10039,//"有效期过短"
    ABCErrorCode_EXPIRATION_TOO_LONG    = 10040,//有效期过长
    ABCErrorCode_INVALID_TIMESTAMP      = 10040 //"时间戳无效"
};

typedef enum : NSUInteger {
    ABCSubject_None = 0,      // 未知学科
    ABCSubject_Math = 1,      // 数学
    ABCSubject_Chinese = 2,   // 语文
    ABCSubject_English = 3,   // 英语
    ABCSubject_Politics = 4,  // 政治
    ABCSubject_History = 5,   // 历史
    ABCSubject_Geology = 6,   // 地理
    ABCSubject_Physics = 7,   // 物理
    ABCSubject_Chemistry = 8, // 化学
    ABCSubject_Biology = 9,   // 生物
    ABCSubject_All = 1000     // 全部类型
} ABCSubject;

@protocol ABCPaitiAuthDelegate<NSObject>

@optional

-(void) refreshNewToken:(void (^)(NSString *token))success
                failure:(void (^)(NSString *msg))fail;

@end

@interface ABCPaitiManager : NSObject

@property(nonatomic, weak) id<ABCPaitiAuthDelegate> delegate;

/*!
 * @method sharedInstance
 & @return 返回实例
 */
+ (instancetype)sharedInstance;

/*
 * 获取搜题结果
 * UIImage :图片压缩控制在2048*2048分辨率内识别更快
 * userId :必填，以便追中来源
 */
-(void) uploadSubjectPicture:(UIImage *)image
                      userId:(NSString *) userId
                    progress:(void (^)(float progress)) uploadProgress
               uploadSuccess:(void (^)(NSString *imagaUrl))uploadSuccess
               searchSuccess:(void (^)(id responseObject))searchSuccess
                     failure:(void (^)(NSError *error))fail;

/*
 * 获取搜题结果
 * imageUrl : 图片地址,图片压缩控制在2048*2048分辨率内识别更快
 */
-(void) apiPaitiGetImageQ:(NSString *) imageUrl
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/*
 * 获取搜题结果
 * 根据题目内容搜题
 */
-(void) apiPaitiGetTextQ:(NSString *) text
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/*
 * 根据question_id 获取题目详情
 */
-(void) apiPaitiGetQAWithQid:(NSString *) qid
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

@end
