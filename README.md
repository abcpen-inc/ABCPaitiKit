## 笔声SDK集成文档
[![Version](https://img.shields.io/cocoapods/v/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![License](https://img.shields.io/cocoapods/l/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)
[![Platform](https://img.shields.io/cocoapods/p/ABCPaiti.svg?style=flat)](http://cocoapods.org/pods/ABCPaiti)

[TOC]

### REVISION HISTORY
Version | Date |Changed By |Changes
------|------|------|------
0.0.1 | 2018-03-26|Bing|init
0.0.2 | 2018-04-13|Bing|fix
0.0.4 | 2018-04-13|wangchun|fix demo
1.0.0 | 2019-05-07|Bing|fix api v2

#### 
# 准备环境
请确保满足一下开发环境要求
> * **Apple XCode 6.0或以上版本**
> * **iOS 9.0或以上版本**

####
# pod导入
```
pod 'ABCPaiti', '~>1.0.0'  
```

### 照相机图片方向(CameraOriType)
| CameraOriType |   描述     | 值 |
| :---------- | :------| :------ |
| CAMERA_ORI_PORTRAIT | 向上 | 1 |
| CAMERA_ORI_LANDSCAPE_LEFT | 向左 | 2 |
| CAMERA_ORI_LANDSCAPE_RIGHT | 向右 | 3 |
| CAMERA_ORI_UPSIDEDOWN | 向下 | 4 |

# 开始接入
## ABCPaitiManager 初始化
> * 这是SDK中的核心类
> * appkey appSecret 请联系笔声申请,并由业务服务端保管
``` 
// 引用ABCPaitiKit头文件
#import <ABCPaitiKit/ABCPaitiKit.h>

// 建议在AppDelegate的didFinishLaunchingWithOptions中设置ABCPaitiAuthDelegate。并实现代理中refreshNewToken的方法

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ABCPaitiManager sharedInstance].delegate = self;
    return YES;
}

-(void) refreshNewToken:(void (^)(NSString *token))success
                failure:(void (^)(NSString *msg))fail
{   
    ....从业务服务器获取accessToken;
}

```

## 相机（ABCCaptureSessionManager）
> * 相机使用方法
```
1、创建该ABCCaptureSessionManager；
2、可以对该session增加一些页面设置的操作。
3、详细使用可见demo中的DemoCameraViewController；
``` 

### 下面介绍相机基本的函数和属性
> * 相机拍摄出的照片默认方向，如果不设置默认为向左（CAMERA_ORI_LANDSCAPE_LEFT）方向

```
@property (nonatomic, assign) CameraOriType defaultOrientation;
``` 

> * 开启摄像头
```
*  @param block  开启完成的block

- (void)startCameraCompletion:(void (^)())completion;
``` 

> * 停止摄像头
```
- (void)stopCamera;
``` 

> * 调用拍照功能
```
*  @param block   block中处理得到的图片（该图片进行了压缩，纠正等相关处理）

- (void)takePicture:(DidCapturePhotoBlock)block;
``` 

> * 调用拍照功能
```
*  @param block   block中处理得到的图片（该图片进行了压缩，纠正等相关处理）
*  @param isOperate （isOperate=YES 对图片进行处理，同takePicture函数；isOperate=NO 不处理图片，返回原图） 
*  
- (void)takePicture:(DidCapturePhotoBlock)block isOperate:(BOOL)isOperate;
``` 

> * 切换摄像头
``` 
*  @param isFrontCamera 是否为前置摄像头
*  
- (void)switchCamera:(BOOL)isFrontCamera;
``` 

> * 闪光灯功能
```
*  @param sender 闪光灯按钮
*  
- (void)switchFlashMode:(UIButton*)sender;
```

> * 在拍照界面中是否显示网格线
```
*  @param toShow 是否显示网格线
*  
- (void)switchGridLines:(BOOL)toShow;
```

## 图片处理(ABCImageUtil)
> *  图片尺寸压缩到1500*1500范围内
```
*  @param input 需要处理的图片
*  
+(UIImage *)constraintToMaxLength:(UIImage *) input;
```
> * 旋转图片为向上正方向
```
*  @param input 需要处理的图片
* 
+(UIImage *)fixOrientation:(UIImage *) input;

```
> * 矫正图片方向（倾斜大于45°不处理）
``` 
*  @param input 需要处理的图片

+ (UIImage *)adjustImageWithAngle:(UIImage *)input;
``` 

> * 矫正图片方向（倾斜大于maxAngle不处理）
```
*  @param input 需要处理的图片
*  @param maxAngle 需要处理的最大角度
*  
+ (UIImage *)adjustImageWithAngle:(UIImage *)input withMaxAngle:(double) maxAngle;
```

> *  图片二值化，如果失败返回nil
```
*  @param image 需要处理的图片
*  
+ (NSString *)genBinPathForImage:(UIImage *)image;
```

> * 判断图片是否清晰
```
*  @param image 需要判断的图片
*  
+ (BOOL)isImageBlur:(UIImage *)image;
```

> * 截取图片
```
*  @param image 需要处理的图片
*  @param rect 截取的坐标位置
*  
+ (UIImage*)crop:(UIImage *)image rect:(CGRect)rect;
```

## 答案识别类(ABCPaitiManager)
> * 图片上传
```
*  @param image   需要上传图片
*  @param progress 进度block
*  @param success 成功
*  @param fail 失败
-(void) uploadSubjectPicture:(UIImage *)image
progress:(void (^)(float progress)) progress
success:(void (^)(id responseObject))success
failure:(void (^)(NSString *strMsg))fail;
```

> *获取本地题目列表（跟机器绑定）
```
*  @param success 成功
*  @param fail 失败

-(void) getQuestionList:(void (^)(id responseObject))success
failure:(void (^)(NSString *strMsg))fail;
```

> * 根据imageId获取配对结果
```
*  @param imageId  图片Id
*  @param success 成功
*  @param fail 失败

-(void) getQuestionAnswers:(NSString *) imageId
success:(void (^)(id responseObject))success
failure:(void (^)(NSString *strMsg))fail;
```

