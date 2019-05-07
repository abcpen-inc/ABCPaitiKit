//
//  ABCQuestionDetailViewController.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/4/13.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ABCQuestionDetailViewController.h"
#import "ABCQuestionPlugin.h"
#import <SDWebImage/SDImageCache.h>
#import <ABCPaitiKit/ABCPaitiKit.h>
#import <MJExtension/MJExtension.h>

@interface ABCQuestionDetailViewController ()

@property(nonatomic, strong) ABCQuestionPlugin *plugin;

@end

@implementation ABCQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plugin =  [self.commandDelegate getCommandInstance:@"ABCQuestionPlugin"];
    _plugin.viewController = self;
    [self initNavigationBar];
}

-(void) initNavigationBar
{
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 44, 44)];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

-(void) btnBackClick:(id) sender
{
    if (self.presentingViewController != nil && self.navigationController.viewControllers.count == 1) {
    [self dismissViewControllerAnimated:YES completion:nil];
}
else [self.navigationController popViewControllerAnimated:YES];
}

-(NSDictionary *)getQueLoadingParams
{
    self.localImgPath=@"";
    
    return @{@"status":@(0),
             @"question":@{@"update_time":self.updateTime?self.updateTime:[NSNull null],
                           @"image_path":_localImgPath?_localImgPath:@""},
             @"machine_answers":@[],
             @"human_answer":[NSNull null],
             @"local_img_path":_localImgPath};
}

-(NSArray *)fillterAnswers:(NSArray *)answers
{
    if (!answers || answers.count==0) {
        return nil;
    }
    
    if (!self.imageId) {
        self.imageId = @"";
    }
    NSMutableArray *results=[NSMutableArray array];
//    NSMutableArray *notEmptyAnswers=[NSMutableArray array];
    [answers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ABCAnswerMo *answer=obj;
        NSMutableDictionary *fillteredAnswer = @{@"questionId":answer.question_id,
                                                 @"answer":answer.question_answer,
                                                 @"image_id":self.imageId,
                                                 @"body":answer.question_body_html,
                                                 @"analysis":answer.answer_analysis,
                                                 @"tags":answer.question_tag,
                                                 @"subject":answer.subject}.mutableCopy;
        [results addObject:fillteredAnswer];
    }];
    return results;
}

-(void)getQueDetailWithCallBack:(void(^)(id sender))callBack
{
    if (_questionAnswersV2Mo && _questionAnswersV2Mo.result) {
        ABCQuestionMo *questionMO = [[ABCQuestionMo alloc] init];
        questionMO.image_id = _questionAnswersV2Mo.image_id;
        questionMO.search_type = 1;
        NSDictionary *quesion = [questionMO mj_keyValues];

        NSArray *answers = [self fillterAnswers:_questionAnswersV2Mo.result];
        if(callBack){
            callBack(@{@"status":@(2),
                       @"question":quesion,
                       @"machine_answers":answers,
                       }
                     );
        }
    }
}

-(void)retakePhoto
{
    
}
-(void)changeTitle:(NSNumber *)page
{
    
}
-(void)cacheImg:(UIImage *)image
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
