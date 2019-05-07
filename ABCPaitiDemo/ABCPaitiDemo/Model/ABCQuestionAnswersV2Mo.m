//
//  ABCQuestionAnswersV2Mo.m
//  ABCPaitiDemo
//
//  Created by bingo on 2019/5/6.
//  Copyright © 2019 杭州喧喧科技有限公司. All rights reserved.
//

#import "ABCQuestionAnswersV2Mo.h"

@implementation ABCQuestionAnswersV2Mo

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"result":@"ABCAnswerMo"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.result forKey:@"result"];
    [aCoder encodeObject:self.raw_text forKey:@"raw_text"];
    [aCoder encodeObject:self.qids forKey:@"qids"];
    [aCoder encodeObject:self.image_id forKey:@"image_id"];

}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.result = [aDecoder decodeObjectForKey:@"result"];
        self.raw_text = [aDecoder decodeObjectForKey:@"raw_text"];
        self.qids = [aDecoder decodeObjectForKey:@"qids"];
        self.image_id = [aDecoder decodeObjectForKey:@"image_id"];
    }
    return self;
}


@end
