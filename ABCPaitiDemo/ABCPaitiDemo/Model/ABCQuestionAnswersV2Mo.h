//
//  ABCQuestionAnswersV2Mo.h
//  ABCPaitiDemo
//
//  Created by bingo on 2019/5/6.
//  Copyright © 2019 杭州喧喧科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCAnswerMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCQuestionAnswersV2Mo : NSObject

@property(nonatomic, strong) NSMutableArray<ABCAnswerMo *> *result;

@property(nonatomic, strong) NSString *raw_text;

@property(nonatomic, strong) NSMutableArray *qids;

@property(nonatomic, strong) NSString *image_id;

@end

NS_ASSUME_NONNULL_END
