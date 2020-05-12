//
//  zkYanPiaoVC.m
//  miaozaishangjiaduan
//
//  Created by kunzhang on 2017/5/25.
//  Copyright © 2017年 kunzhang. All rights reserved.
//

#import "zkYanPiaoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
//#import <MJRefresh.h>
#import "UIView+KKEB.h"

#define SSSSBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define kImageMaxSize   CGSizeMake(1000, 1000)

@interface zkYanPiaoVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL bHadAutoVideoZoom;
}
//会话和图层需要声明成属性，因为代理方法中需要使用
@property (nonatomic, weak) AVCaptureSession *session;
/** 显示的预览图层 */
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;
/** UIImageView */
@property(nonatomic , strong)UIImageView *imageView;
/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) CALayer *containerLayer;
/** 显示扫描的结果 */
@property(nonatomic , strong)UILabel *customLabel;

/*动画的图*/
@property (nonatomic , strong)UIImageView * dongHuaImgV;

/*数据*/
@property (nonatomic , strong)NSString * dingDanID;
/*数据数组*/
@property (nonatomic , strong)NSMutableArray * dataArray;

@property (nonatomic,strong)AVCaptureDevice* device;



@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (nonatomic, strong) UIView *videoPreView; ///视频预览显示视图
@property (nonatomic, assign) CGPoint centerPoint;//二维码的中心点
@property (nonatomic, assign) BOOL isAutoOpen;//默认NO 闪光灯

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;//拍照

@end

@implementation zkYanPiaoVC

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (CALayer *)containerLayer
{
    if (_containerLayer == nil) {
        _containerLayer = [[CALayer alloc] init];
    }
    return _containerLayer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXWX:) name:@"WXPAY" object:nil];
    [self.session startRunning];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.session stopRunning];
}

- (void)WXWX:(NSNotification *)obj{
    
    
    CGRect frame = self.imageView.frame;
    [UIView animateWithDuration:3 delay:1 options:UIViewAnimationOptionRepeat animations:^{
        
        self.dongHuaImgV.y = frame.size.height;
        
    } completion:^(BOOL finished) {
        self.dongHuaImgV.y = -260;
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    if (![self isCanUsePhotos]) {
        
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相册""中允许访问" preferredStyle:(UIAlertControllerStyleAlert)] ;
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }] ;
        
        [alertVC addAction:action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    self.navigationItem.title = @"扫一扫";
    //    UIButton * leftBt =[UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBt.frame = CGRectMake(0, 0, 24, 24);
    //    [leftBt setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    [leftBt addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    //    leftBt.tag = 255;
    //    UIBarButtonItem * leftItme =[[UIBarButtonItem alloc] initWithCustomView:leftBt];
    //    self.navigationItem.leftBarButtonItem = leftItme;
    //
    
    self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(60, 150 , ScreenW - 120, ScreenW - 120)];
    self.imageView.image =[UIImage imageNamed:@"zk_kuang"];
    [self.view addSubview:self.imageView];
    self.imageView.backgroundColor =[UIColor colorWithWhite:0 alpha:0];
    
    self.view.backgroundColor =[UIColor blackColor];
    
    CGRect frame = self.imageView.frame;
    
    self.dongHuaImgV =[[UIImageView alloc] initWithFrame:CGRectMake(0, -260, frame.size.width, 260)];
    self.dongHuaImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.dongHuaImgV.image =[UIImage imageNamed:@"zk_wangge"];
    
    [self.imageView addSubview:self.dongHuaImgV];
    self.imageView.clipsToBounds = YES;
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:3 delay:1 options: UIViewAnimationOptionRepeat animations:^{
            self.dongHuaImgV.y = frame.size.height;
        } completion:^(BOOL finished) {
            self.dongHuaImgV.y = -260;
        }];
    });
    
    
//    //对焦手势,方法在下面
//    [self addGenstureRecognizer];
    
    
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    // 2.添加输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    self.input = input;
    self.device = device;
    if (![self.session canAddInput:input]) {
        return;
    }
    [session addInput:input];
    // 3.添加输出数据
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if (![self.session canAddOutput:output]) {
        return;
    }
    [session addOutput:output];
    
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([session canAddOutput:self.stillImageOutput]){
        [session addOutput:self.stillImageOutput];
    }

    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:device];
    
    //设置扫描敏感区域，frame为想要扫描的敏感区域
    output.rectOfInterest =[self rectOfInterestByScanViewRect:self.imageView.frame];
    // 3.1.设置输入元数据的类型(类型是二维码数据和条形码)
    // output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    output.metadataObjectTypes = output.availableMetadataObjectTypes;
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    layer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:layer];
    
    [self.view insertSubview:self.videoPreView atIndex:0];
    [self.videoPreView.layer insertSublayer:layer atIndex:0];

    
    
    UIView * topView =[[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenW ,CGRectGetMinY(self.imageView.frame))];
    topView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:topView];
    
    UIView * bottomView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.imageView.frame),ScreenW ,ScreenH - CGRectGetMaxY(self.imageView.frame))];
    bottomView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:bottomView];
    
    UIView * LeftView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.imageView.frame),CGRectGetMinX(self.imageView.frame) ,frame.size.height)];
    LeftView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:LeftView];
    
    
    UIView * rightView =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame),CGRectGetMinY(self.imageView.frame),ScreenW - CGRectGetMaxX(self.imageView.frame) ,frame.size.height)];
    rightView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:rightView];
    
    UILabel * LLb =[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageView.frame) + 15 , ScreenW - 30, 20)];
    LLb.font =[UIFont systemFontOfSize:16];
    LLb.textColor = [UIColor whiteColor];
    LLb.textAlignment = NSTextAlignmentCenter;
    LLb.text = @"请对准设备二维码";
    [self.view addSubview:LLb];
    
    [self.view.layer addSublayer:self.imageView.layer];
    
    UIButton * phoneBt =[UIButton buttonWithType:UIButtonTypeCustom];
    phoneBt.frame = CGRectMake(ScreenW - 30-50, CGRectGetMaxY(LLb.frame) + 30   , 50, 50);
    [phoneBt addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneBt setBackgroundImage:[UIImage imageNamed:@"zk_xiangce"] forState:UIControlStateNormal];
    //此处把相册功能关闭
    [self.view addSubview:phoneBt];
    
    
    UIButton * kaiGuanBt =[UIButton buttonWithType:UIButtonTypeCustom];
    kaiGuanBt.frame = CGRectMake(ScreenW - 30-50 - 70, CGRectGetMaxY(LLb.frame) + 30   , 50, 50);
    [kaiGuanBt addTarget:self action:@selector(kaidengAction:) forControlEvents:UIControlEventTouchUpInside];
    [kaiGuanBt setBackgroundImage:[UIImage imageNamed:@"zk_dengguan"] forState:UIControlStateNormal];
    [kaiGuanBt setBackgroundImage:[UIImage imageNamed:@"zk_dengkai"] forState:UIControlStateSelected];
    [self.view addSubview:kaiGuanBt];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, SSSSBarH + 2, 40, 40)];
    [button setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.view.layer addSublayer:self.containerLayer];
    //描边图层
    self.containerLayer.frame = self.view.bounds;
    //预览图层
    self.layer = layer;
    
    
     [input.device lockForConfiguration:nil];
    //自动平衡
    if ([self.device isWhiteBalanceModeSupported:(AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance)]) {
        [input.device setWhiteBalanceMode:(AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance)];
    }
    //自动曝光
    if ([self.device isExposureModeSupported:(AVCaptureExposureModeContinuousAutoExposure)]) {
        [input.device setExposureMode:(AVCaptureExposureModeContinuousAutoExposure)];
    }
    
    if(self.device.isFocusPointOfInterestSupported && [self.device isFocusModeSupported:(AVCaptureFocusModeContinuousAutoFocus)]) {
        [input.device setFocusMode:(AVCaptureFocusModeContinuousAutoFocus)];
    }
    
    
    // 5.开始扫描
    [session startRunning];
    
    bHadAutoVideoZoom = NO;//还未自动拉近的值
    [self setVideoScale:1 ];//设置拉近倍数为1
    
}


#pragma mark - get
- (UIView *)videoPreView{
    if (!_videoPreView) {
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        videoView.backgroundColor = [UIColor clearColor];
        _videoPreView = videoView;
    }
    return _videoPreView;
}

- (void)setVideoScale:(CGFloat)scale
{
    [self.input.device lockForConfiguration:nil];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat maxScaleAndCropFactor = ([[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor])/16;
    
    if (scale > maxScaleAndCropFactor){
        scale = maxScaleAndCropFactor;
    }else if (scale < 1){
        scale = 1;
    }
    
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    videoConnection.videoScaleAndCropFactor = scale;
    
    [self.input.device unlockForConfiguration];
    
    CGAffineTransform transform = self.videoPreView.transform;
    
    //自动拉近放大
    if (scale == 1) {
        self.videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
        CGRect rect = self.videoPreView.frame;
        rect.origin = CGPointZero;
        self.videoPreView.frame = rect;
    } else {
        CGFloat x = self.videoPreView.center.x - self.centerPoint.x;
        CGFloat y = self.videoPreView.center.y - self.centerPoint.y;
        CGRect rect = self.videoPreView.frame;
        rect.origin.x = rect.size.width / 2.0 * (1 - scale);
        rect.origin.y = rect.size.height / 2.0 * (1 - scale);
        rect.origin.x += x * zoom;
        rect.origin.y += y * zoom;
        rect.size.width = rect.size.width * scale;
        rect.size.height = rect.size.height * scale;
        
        [UIView animateWithDuration:.5f animations:^{
            self.videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
            self.videoPreView.frame = rect;
        } completion:^(BOOL finished) {
        }];
    }
    
    NSLog(@"放大%f",zoom);
}


- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}


////手动对焦
//-(void)addGenstureRecognizer{
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
//    [self.imageView addGestureRecognizer:tapGesture];
//}
//- (void)tapScreen:(UITapGestureRecognizer*)gesture{
//    CGPoint point = [gesture locationInView:gesture.view];
//    [self focusAtPoint:point];
//}
//
//- (void)focusAtPoint:(CGPoint)point{
//    CGSize size = self.view.bounds.size;
//    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
//    NSError *error;
//    if ([self.device lockForConfiguration:&error]) {
//        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//            [self.device setFocusPointOfInterest:focusPoint];
//            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
//        }
//        [self.device unlockForConfiguration];
//    }
//    [self setFocusCursorWithPoint:point];
//}
//
//
////自动对焦
//- (void)subjectAreaDidChange:(NSNotification *)notification
//{
//    //先进行判断是否支持控制对焦
//    if (_device.isFocusPointOfInterestSupported &&[_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//        NSError *error =nil;
//        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
//        [_device lockForConfiguration:&error];
//        [_device setFocusMode:AVCaptureFocusModeAutoFocus];
//        [self focusAtPoint:_imageView.center];
//        //操作完成后，记得进行unlock。
//        [_device unlockForConfiguration];
//    }
//}
//
//-(void)setFocusCursorWithPoint:(CGPoint)point{
//    //下面是手触碰屏幕后对焦的效果
//    _imageView.center = point;
//    _imageView.hidden = NO;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        _imageView.transform = CGAffineTransformMakeScale(1.25, 1.25);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _imageView.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//
//
//        }];
//    }];
//
//}





-(void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//从照片中选择二维码
- (void)phoneAction {
    //1.0判断相册是否可以打开
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    } else {
        //创建图片选择控制器
        UIImagePickerController * ipc =[[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理
        ipc.delegate = self;
        //modal 出这个控制器
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
}

//代开闪关灯
- (void)kaidengAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
    
    
}

//计算主要扫描区域
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    // 注意这里的x，y， w，h计算方法
    CGFloat x = rect.origin.y / height;
    CGFloat y = rect.origin.x / width;
    
    CGFloat w = rect.size.height / height;
    CGFloat h = rect.size.width / width;
    
    return CGRectMake(x, y, w, h);
}

//实现代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //id 类型不能用点又发,所以哟啊西安取出数组中的对象
    AVMetadataMachineReadableCodeObject * object =[metadataObjects lastObject];
    if (object == nil) {
        return;
    } else {
        
        [self.session stopRunning];
        
        //只要扫描到数据就会调用的
        self.customLabel.text = object.stringValue;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.sendStrBlock != nil) {
                self.sendStrBlock(object.stringValue);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });

        
        
        
        
        //        if ([object.stringValue hasPrefix:@"FM-"]) {
        //
        //
        //
        //        }else {
        //
        //
        //            return;
        //        }
        //
        
        NSLog(@"=========%@",object.stringValue);
        //        [self.dataArray removeAllObjects];
        //        self.dataArray = [object.stringValue componentsSeparatedByString:@"&"].mutableCopy;
        //
        //        NSArray * arr = [self.dataArray[0] componentsSeparatedByString:@"="];
        //
        //        self.dingDanID = [arr lastObject];
        //
        //        [self yanPiaoAction];
        
        // 清除之前的描边
        // [self clearLayers];
        
        // 对扫描到的二维码进行描边
        //AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[self.layer transformedMetadataObjectForMetadataObject:object];
        
        // 绘制描边
        // [self drawLine:obj];
    }
    
    
}


//选择图片的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //取出图片
    //取出图片,要进行处理
    UIImage * image =[self resizeImage:info[UIImagePickerControllerOriginalImage]];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    //2.0从选中的图片读取二维码数据
    //2.1 创建一个探视器
    CIDetector * detector =[CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    //2.2 利用探视器探测数据
    NSArray * feature =[detector featuresInImage:ciImage];
    //2.3 取出探测器的数据
    for(CIQRCodeFeature * result in feature) {
        
        //图片的二维码
        NSLog(@"%@",result.messageString);
        NSString *urlStr = result.messageString;
        
        [self.dataArray removeAllObjects];
        self.dataArray = [result.messageString componentsSeparatedByString:@"&"].mutableCopy;
        NSArray * arr = [self.dataArray[0] componentsSeparatedByString:@"="];
        self.dingDanID = [arr lastObject];
        [self yanPiaoAction];
        
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{@"1251":@121} completionHandler:^(BOOL success) {
        //
        //
        //        }];
        //
        
    }
    // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)resizeImage:(UIImage *)image {
    
    if (image.size.width < kImageMaxSize.width && image.size.height < kImageMaxSize.height) {
        return image;
    }
    
    CGFloat xScale = kImageMaxSize.width / image.size.width;
    CGFloat yScale = kImageMaxSize.height / image.size.height;
    CGFloat scale = MIN(xScale, yScale);
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}


#pragma mark -判断相机相册权限
- (BOOL)isCanUsePhotos {
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}
- (BOOL)isCanUsePicture{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
    return YES;
}

//跳转用
- (void)yanPiaoAction {
    //    [ZKLoading show];
    
    
    
}


- (void)itemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
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
