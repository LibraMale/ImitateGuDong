//
//  LLSportCameraViewController.m
//  ImitateGuDong
//
//  Created by LibraLiu on 16/10/30.
//  Copyright © 2016年 LL. All rights reserved.
//

#import "LLSportCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LLSportCameraViewController ()
/**
 预览视图
 */
@property (weak, nonatomic) IBOutlet UIView *previewView;
/**
 水印图像视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *waterprintImageView;
/**
 距离标签
 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

/**
 快门约束数组
 */
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *maskViewConstraints;

@end

@implementation LLSportCameraViewController{
    /// 拍摄会话
    AVCaptureSession *_captureSession;
    /// 输入设备 - 摄像头
    AVCaptureDeviceInput *_inputDevice;
    /// 图像输出
    AVCaptureStillImageOutput *_imageOutput;
    /// 取景框 - 预览图层
    AVCaptureVideoPreviewLayer *_previewLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置拍摄会话
    [self setupCaptureSession];
}

// 隐藏prefersStatusBar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

/**
 切换摄像头
 */
- (IBAction)switchCamera {
    // AVCaptureConnection 表示图像和摄像头的连接
    // 0. 具体的设备 - 摄像头／麦克风(模拟器没有摄像头，应该使用真机测试)
    AVCaptureDevice *device = [self captureDevice];
    
    // 1. 创建输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // 停止拍摄会话
    [self stopCapture];
    
    // 删除之前的输入设备
    [_captureSession removeInput:_inputDevice];
    
    // 2. 判断设备能否被添加 - 如果已经有摄像头在会话中，不能添加新的设备
    if ([_captureSession canAddInput:input]) {
        _inputDevice = input;
    }
    
    // 3. 添加到会话
    [_captureSession addInput:_inputDevice];
    
    // 4. 重新启动会话
    [self startCapture];
}
/**
 拍照
 */
- (IBAction)capture {
    // 关闭快门
    [self maskViewAminWithClose:YES];
    
    // 拍照和保存
    [self capturePicture];
    
    // 打开快门
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self maskViewAminWithClose:NO];
    });
}
/**
 快门动画
 
 @param close 是否关闭快门
 */
- (void)maskViewAminWithClose:(BOOL)close {
    
    if (close) {
        // 禁用选中的约束
        [NSLayoutConstraint deactivateConstraints:_maskViewConstraints];
    } else {
        // 启用选中的约束
        [NSLayoutConstraint activateConstraints:_maskViewConstraints];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - 相机相关方法

/**
 开始拍摄
 */
- (void)startCapture {
    [_captureSession startRunning];
}

/**
 停止拍摄
 */
- (void)stopCapture {
    [_captureSession stopRunning];
}

/**
 拍照和保存
 */
- (void)capturePicture {
    
    // AVCaptureConnection 表示图像和摄像头的连接
    AVCaptureConnection *conn = _imageOutput.connections.firstObject;
    
    if (conn == nil) {
        NSLog(@"无法连接到摄像头");
        
        return;
    }
    
    // 拍摄照片
    [_imageOutput captureStillImageAsynchronouslyFromConnection:conn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        // 判断是否有图像数据的采样缓冲区
        if (imageDataSampleBuffer == nil) {
            NSLog(@"没有图像数据采样缓冲区");
            
            return;
        }
        
        // 使用图像数据采样缓冲区生成照片的数据
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        // 使用数据生成图像 - 几乎可以显示在一个完整的视图中
        UIImage *image = [UIImage imageWithData:data];
        
        // 将图像的上下两部分不显示在预览图层中的内容裁切掉！
        // 1> 预览视图的大小
        CGRect rect = self.previewView.bounds;
        
        // 2> 计算裁切掉的大小
        CGFloat offset = (self.view.bounds.size.height - rect.size.height) * 0.5;
        
        // 3> 利用图像上下文来裁切图像
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        
        // 4> 绘制图像
        [image drawInRect:CGRectInset(rect, 0, -offset)];
        
        // 水印图像
        [self.waterprintImageView.image drawInRect:self.waterprintImageView.frame];
        
        // 距离标签
        [self.distanceLabel.attributedText drawInRect:self.distanceLabel.frame];
        
        // 5> 从图像上下文获取绘制结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6> 关闭上下文
        UIGraphicsEndImageContext();
        
        // 保存图像
        UIImageWriteToSavedPhotosAlbum(result, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}

/**
 保存相片结束的回调方法
 
 @param image       图像
 @param error       错误
 @param contextInfo 上下文
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = (error == nil) ? @"照片保存成功" : @"照片保存失败";
    
    NSLog(@"%@", msg);
}


/**
 设置拍摄会话
 */
- (void)setupCaptureSession {
    
    // 0. 具体的设备 - 摄像头／麦克风(模拟器没有摄像头，应该使用真机测试)
    AVCaptureDevice *device = [self captureDevice];
    
    // 1. 输入设备 - 可以添加到拍摄会话
    _inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // 2. 输出图像
    _imageOutput = [AVCaptureStillImageOutput new];
    
    // 3. 拍摄会话
    _captureSession = [AVCaptureSession new];
    
    // 4. 将输入／输出添加到拍摄会话
    // 为了避免因为客户手机的设备故障以及其他原因，通常需要判断设备能否添加到会话
    if (![_captureSession canAddInput:_inputDevice]) {
        NSLog(@"无法添加输入设备");
        
        return;
    }
    
    if (![_captureSession canAddOutput:_imageOutput]) {
        NSLog(@"无法添加输出设备");
        
        return;
    }
    
    [_captureSession addInput:_inputDevice];
    [_captureSession addOutput:_imageOutput];
    
    // 5. 设置预览图层
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    
    // 指定图层的大小 - 模态展现的，在 viewDidLoad 方法中，视图的大小还没有确定
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height -= 130;
    _previewLayer.frame = rect;
    
    // 添加图层到预览视图
    [_previewView.layer insertSublayer:_previewLayer atIndex:0];
    
    // 设置取景框的拉伸效果 - 在实际开发中，统一使用 AVLayerVideoGravityResizeAspectFill
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 6. 开始拍摄
    [self startCapture];
}
/**
  切换摄像头
  
  @return 如果 _inputDevice 有值，要根据对应的摄像头对调，如果没有值，返回后置摄像头
  */
- (AVCaptureDevice *)captureDevice {
    
    // 获取当前输入设备的镜头位置
    AVCaptureDevicePosition position = _inputDevice.device.position;
    
    position = (position != AVCaptureDevicePositionBack) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    // 摄像头数组
    NSArray *array = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 获取后置摄像头
    AVCaptureDevice *device;
    for (AVCaptureDevice *obj in array) {
        if (obj.position == position) {
            device = obj;
            
            break;
        }
    }
    
    return device;
}

@end

