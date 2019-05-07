//
//  ViewController.m
//  ABCPaitiDemo
//
//  Created by bingo on 2018/3/18.
//  Copyright © 2018年 杭州喧喧科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import <ABCPaitiKit/ABCPaitiKit.h>
#import "DemoCameraViewController.h"
#import <MJExtension/MJExtension.h>
#import "ABCQuestionAnswersMo.h"
#import "ABCQuestionDetailViewController.h"
#import "ABCQuestionAnswersV2Mo.h"

#define ABC_APP_KEY     @"5aac840df1664467549b1fba"
#define ABC_APP_SECRET  @"F0B732122E7CADAC4D857E2C25050C7C"

////教师端
//#define ABC_APP_KEY     @"5554527E474347F01EDB267A"
//#define ABC_APP_SECRET  @"BDECB2E9C8F6887FF31D5AC6DA312D85";

////对外
//#define ABC_APP_KEY     @"5577E6CCE4B0CDD74AE31C7E"
//#define ABC_APP_SECRET  @"64F682C06F2A719D1902CE7C8E5CAA07";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startPaiti:(id)sender {
    BOOL isCamrma = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamrma) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_title", @"alert_title") message:NSLocalizedString(@"alert_no_backcamera", @"alert_no_backcamera") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    DemoCameraViewController *cameraViewController = [[DemoCameraViewController alloc] init];
    
    [self presentViewController:cameraViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:cameraViewController animated:YES];
}
- (IBAction)getQAWithQid:(id)sender {
    [SVProgressHUD showWithStatus:@"识别中..."];
    [[ABCPaitiManager sharedInstance] apiPaitiGetQAWithQid:@"202274903" success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSMutableArray *answers = [ABCAnswerMo mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        ABCQuestionAnswersV2Mo *mo = [[ABCQuestionAnswersV2Mo alloc] init];
        mo.result = answers;
        ABCQuestionDetailViewController *qDetailViewCtrl = [[ABCQuestionDetailViewController alloc] init];
        qDetailViewCtrl.questionAnswersV2Mo = mo;
        qDetailViewCtrl.imageId = mo.image_id;
        [self.navigationController pushViewController:qDetailViewCtrl animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)searchWIthImageUrl:(id)sender {
    [SVProgressHUD showWithStatus:@"识别中..."];
    [[ABCPaitiManager sharedInstance] apiPaitiGetImageQ:@"http://abc-test.oss-cn-shanghai.aliyuncs.com/paiti/1557063911436.jpg" success:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ABCQuestionAnswersV2Mo *mo = [ABCQuestionAnswersV2Mo mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        ABCQuestionDetailViewController *qDetailViewCtrl = [[ABCQuestionDetailViewController alloc] init];
        qDetailViewCtrl.questionAnswersV2Mo = mo;
        qDetailViewCtrl.imageId = mo.image_id;
        [self.navigationController pushViewController:qDetailViewCtrl animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)searWithText:(id)sender {
    [SVProgressHUD showWithStatus:@"识别中..."];
    [[ABCPaitiManager sharedInstance] apiPaitiGetTextQ:@"长方体和正方体都有六个面，而且六个面都相同。（  ）" success:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [SVProgressHUD dismiss];
        ABCQuestionAnswersV2Mo *mo = [ABCQuestionAnswersV2Mo mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        ABCQuestionDetailViewController *qDetailViewCtrl = [[ABCQuestionDetailViewController alloc] init];
        qDetailViewCtrl.questionAnswersV2Mo = mo;
        qDetailViewCtrl.imageId = mo.image_id;
        [self.navigationController pushViewController:qDetailViewCtrl animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
