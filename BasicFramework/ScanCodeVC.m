//
//  ScanCodeVC.m
//  BasicFramework
//
//  Created by 我叫哀木涕 on 2017/2/22.
//  Copyright © 2017年 我叫哀木涕. All rights reserved.
//
/*
 
 二维码扫描的步骤：
 1、创建设备会话对象，用来设置设备数据输入
 2、获取摄像头，并且将摄像头对象加入当前会话中
 3、实时获取摄像头原始数据显示在屏幕上
 4、扫描到二维码/条形码数据，通过协议方法回调
 
 AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
 AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
 AVCaptureMetadataOutput 输出类。这个支持二维码、条形码等图像数据的识别
 AVCaptureVideoPreviewLayer 图层类。用来快速呈现摄像头获取的原始数据
 二维码扫描功能的实现步骤是创建好会话对象，用来获取从硬件设备输入的数据，并实时显示在界面上。在扫描到相应图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
 */
#import "ScanCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeView.h"
@interface ScanCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>
///会话对象
@property (nonatomic,strong) AVCaptureSession *session;
///图层类
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) ScanCodeView *scanView;



@end

@implementation ScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"扫一扫";
    self.scanView = [[ScanCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ///二维码扫描
    [self setupScanQRCode];
}
///二维码扫描
- (void)setupScanQRCode{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    output.rectOfInterest = CGRectMake(0.15, 0.24, 0.7, 0.52);
    
    // 5、 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    // 8、将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];

}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSLog(@"metadataObjects = %@", metadataObjects);
        
        if ([obj.stringValue hasPrefix:@"http"]) {
            // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
//            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//            jumpVC.jump_URL = obj.stringValue;
//            NSLog(@"stringValue = = %@", obj.stringValue);
//            [self.navigationController pushViewController:jumpVC animated:YES];
            
        } else { // 扫描结果为条形码
            
//            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//            jumpVC.jump_bar_code = obj.stringValue;
//            NSLog(@"stringValue = = %@", obj.stringValue);
//            [self.navigationController pushViewController:jumpVC animated:YES];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
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
