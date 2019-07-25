//
//  ViewController.m
//  FangZhiAPP
//
//  Created by zk on 2019/6/17.
//  Copyright © 2019 张坤. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIView+KKEB.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "zkYanPiaoVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "zkShowVIew.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "WBQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UICKeyChainStore.h"


#define SSSSBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define HHHHHH [UIScreen mainScreen].bounds.size.height
#define WWWWW [UIScreen mainScreen].bounds.size.width
#define  URLURL @"http://www.movida-italy.com/app/index.asp"



//#define  URLURL [@"http://www.movida-italy.com/app/index.asp" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
@interface ViewController ()<UIWebViewDelegate,zkShowVIewDelegate>
@property (nonatomic,weak) JSContext * context;
@property(nonatomic,strong)UIButton *settingBt;
@property(nonatomic,strong)UIView *backV;
@property(nonatomic,strong)NSArray *dataArray;
/** s */
@property(nonatomic , strong)zkShowVIew *showView;
/**  */
@property(nonatomic , strong)UIView *backView;
/**  */
@property(nonatomic , assign)BOOL isShow;
@end

@implementation ViewController

-(zkShowVIew *)showView {
    if (_showView == nil) {
        _showView = [[zkShowVIew alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH-45)];
        if (SSSSBarH>20) {
            _showView.mj_h = HHHHHH - 45-34;
        }
        _showView.deleate = self;
    }
    return _showView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    
    
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0];
    
    UIWebView * web =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH-45)];
    if (SSSSBarH > 20) {
        web.mj_h = HHHHHH - 45 - 34;
    }
    [self.view addSubview: web];
    self.webView = web;
    self.view.backgroundColor = [UIColor whiteColor];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    
    //设备ID
    
    NSString * dddddddd = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    NSString *device  = [keychainStore stringForKey:@"FangZhipasswordabc"];

    if (device.length == 0) {
      device = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
      BOOL isOK  = [keychainStore setString:[NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]] forKey:@"FangZhipasswordabc"];
    }

    NSString *encodedString=[[NSString stringWithFormat:@"%@?imei=%@",URLURL,device] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    web.scrollView.bounces = NO;

    //    web.backgroundColor =[UIColor redColor];
    
//    self.backV = [[UIView alloc] initWithFrame:CGRectMake(WWWWW - 60 - 10, HHHHHH  - 15 - 60 - 49 - 120 , 60, 180)];
//    if (SSSSBarH > 20) {
//        self.backV.frame = CGRectMake(WWWWW - 60 - 10, HHHHHH  - 34 - 15 - 60 - 49 - 120 , 70, 180);
//        web.frame = CGRectMake(0, SSSSBarH, WWWWW, HHHHHH - SSSSBarH - 34);
//    }
//    [self.view addSubview:self.backV];
//    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    imageV.userInteractionEnabled = YES;
//    imageV.image = [UIImage imageNamed:@"kk_zuoyou"];
//    [self.backV addSubview:imageV];
//    UIPanGestureRecognizer * sg = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backPan:)];
//    [imageV addGestureRecognizer:sg];
 
//    for (int i = 0 ; i < 2 ; i++) {
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake( 0 , 60 * i + 60 , 60, 60);
//        button.tag = i;
//        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"kk_%d",i]] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.backV addSubview:button];
//    }
    
    

    
    self.backV = [[UIView alloc] initWithFrame:CGRectMake(0, HHHHHH-40, WWWWW, 45)];
    self.backV.backgroundColor =[UIColor blackColor];
    [self.view addSubview:self.backV];
    
    UIButton * leftbb =[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 45, 45)];
    [leftbb setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftbb.tag = 100;
    [leftbb addTarget:self action:@selector(actionTwo:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * rightbb =[[UIButton alloc] initWithFrame:CGRectMake(WWWWW - 55, 0, 45, 45)];
    [rightbb setImage:[UIImage imageNamed:@"sandian"] forState:UIControlStateNormal];
    rightbb.tag = 101;
    [rightbb addTarget:self action:@selector(actionTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self.backV addSubview:leftbb];
     [self.backV addSubview:rightbb];
    
    
}

-(void)doSwipe:(UISwipeGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (point.x > ([UIScreen mainScreen].bounds.size.width/2.0) + 40 && point.x < [UIScreen mainScreen].bounds.size.width - 40 - 15){
        self.settingBt.frame = CGRectMake(point.x, SSSSBarH + 2 , 40 , 40);
    }
}

-(void)backPan:(UISwipeGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    CGPoint point2 = [sender locationInView:self.backV];
    NSLog(@"%@",NSStringFromCGPoint(point));
    NSLog(@"===\n%@",NSStringFromCGPoint(point2));
    CGFloat x = 0;
    CGFloat y = 0;
    if (point.x < 0) {
        x = 0;
    }else if (point.x > [UIScreen mainScreen].bounds.size.width - 60) {
        x = [UIScreen mainScreen].bounds.size.width - 60;
    }else {
        x = point.x;
    }
    
    if (point.y < SSSSBarH + 44) {
        y = SSSSBarH + 44;
    }else if (point.y > HHHHHH - 49  - 180) {
        y = HHHHHH - 49 - 180;
    }else {
        y = point.y;
    }
    self.backV.x = x;
    self.backV.y = y;
}

- (void)swipeGes:(UISwipeGestureRecognizer *)swipeGes {
    CGPoint point = [swipeGes locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (( point.x > 0 && point.x < [UIScreen mainScreen].bounds.size.width - 60) && (point.y > (SSSSBarH + 44) && point.y < HHHHHH - 49 - 34 - 180)){
        self.backV.frame = CGRectMake(point.x, point.y , 70 , 180);
    }
}

- (void)clickAction:(UIButton *)button {
    if (button.tag == 0) {
        if([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }else if (button.tag == 1) {
        
        //        [self shareWithSetPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ)] withUrl:@"" shareModel:nil];
        
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLURL]]];
        
        //
        //        [self shareWithSetPreDefinePlatforms:nil withArr:@[@"123",@"456"]];
        //        return;
        //
        //          [self fetchAddressBookOnIOS9AndLater];
        //        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        //            NSDictionary * dict = @{@"code":@(1),@"data":[self.dataArray subarrayWithRange:NSMakeRange(0, 6)]};
        //            NSString * atrr =  [self convertToJsonDataWithDict:dict];
        //            NSLog(@"\n====%@",atrr);
        //            [SVProgressHUD showSuccessWithStatus:atrr];
        //        }else {
        //            NSDictionary * dict = @{@"code":@(-1),@"data":@[]};
        //            NSString * atrr =  [self convertToJsonDataWithDict:dict];
        //            NSLog(@"\n====%@",atrr);
        //            [SVProgressHUD showSuccessWithStatus:atrr];
        //
        //        }
        
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载网页");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除web 的缓存
    //    [SVProgressHUD show];
}



//JS 调用OC 方法并且传参,要你管啊 你想也不想啊 干啥的额
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSURL *url = webView.request.URL;
    NSString *scheme = [url scheme];
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    NSLog(@"%@",@"网页加载王城");
    //获取JS运行环境
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //html 调用无惨OC
    _context[@"devicetoken"] =^() {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    };
    __weak typeof(self) weakSelf = self;
    _context[@"js2java"] = ^() {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            WBQRCodeVC * vc =[[WBQRCodeVC alloc] init];
            vc.sendStrBlock = ^(NSString *str) {
                
                [weakSelf.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"alertMessage('%@')",str]];
                
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });

    };
    

}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error) {
        NSLog(@"\nerror === %@",error.description);
    }
    
    if (error.code == NSURLErrorCancelled || error.code == NSURLErrorNetworkConnectionLost) {
        return;
    }
    
    UIAlertController * avc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"errorCode == %ld",(long)error.code] message:error.description preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [avc addAction:action];
    
    [self presentViewController:avc animated:YES completion:nil];
    
}

- (void)getMessage:(NSString *)str {
    NSLog(@"%@",str);
}

#pragma 供JS调用的方法
-(void)menthod1{
    NSLog(@"JS调用了无参数OC方法");
}
-(void)menthod2:(NSString *)str1 and:(NSString *)str2{
    NSLog(@"%@%@",str1,str2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma OC调用JS方法
-(void)function1{
    [_webView stringByEvaluatingJavaScriptFromString:@"aaa()"];
}
-(void)function2{
    NSString * name = @"pheromone";
    NSInteger num = 520;//准备传去给JS的参数
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"bbb('%@','%ld');",name,num]];
}


- (void)shareWithSetPreDefinePlatforms:(NSArray *)platforms withArr:(NSArray *)arr {
    
    
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareImageAndTextToPlatformType:platformType withArr:arr];
    }];
    
    
    
}




//分享
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType withArr:(NSArray *)arr
{
    NSString * url = @"";
    NSString *title = @"共享用";
    NSString * logoStr = @"";
    NSString *descStr = @"最好的app等你来玩!";
    if (arr.count > 0) {
        title = [NSString stringWithFormat:@"%@",arr[0]];
    }
    if (arr.count > 1) {
        descStr = [NSString stringWithFormat:@"%@",arr[1]];
    }
    if (arr.count > 2) {
        logoStr = [NSString stringWithFormat:@"%@",arr[2]];
    }
    if (arr.count > 3) {
        url = [NSString stringWithFormat:@"%@",arr[3]];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if ([url hasSuffix:@".jpg"] || [url hasSuffix:@".JPG"] || [url hasSuffix:@".jpeg"] || [url hasSuffix:@".JPEG"] || [url hasSuffix:@".gif"] || [url hasSuffix:@".GIF"] || [url hasSuffix:@".png"]|| [url hasSuffix:@".PNG"] || [url hasSuffix:@".bmp"] || [url hasSuffix:@".BMP"]) {
        //设置文本
        messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        if (logoStr.length == 0 || [logoStr isEqualToString:@"(null)"] || [logoStr isEqualToString:@"<null>"] || [logoStr isEqualToString:@"[object Object]"]) {
            shareObject.thumbImage = [UIImage imageNamed:@"logo"];
        }else {
            shareObject.thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]]];;
        }
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        [shareObject setShareImage:image];
        messageObject.shareObject = shareObject;
    }else {
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descStr thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]]]];
        if (logoStr.length == 0 || [logoStr isEqualToString:@"(null)"] || [logoStr isEqualToString:@"<null>"] ) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descStr thumImage:[UIImage imageNamed:@"logo"]];
        }
        //设置网页地址
        shareObject.webpageUrl =url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)actionTwo:(UIButton *)button {
    if (button.tag == 100) {
        if([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }else {
        if (self.showView.isShow){
            [self.showView diss];
        }else {
            
            [self.view addSubview:self.showView];
            [self.showView show];
        }
        
        
    }
}


#pragma mark ---- 点击弹框----
- (void)didClickIndex:(NSInteger)index {
    if (index == 0) {
 
        [self cleanCacheAndCookie];
        
    }else if (index == 1){
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            __weak typeof(self) weakSelf = self;
//            zkYanPiaoVC * vc =[[zkYanPiaoVC alloc] init];
//            vc.sendStrBlock = ^(NSString *str) {
//                if ([str hasPrefix:@"http"]) {
//                    [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                }else {
//                    [SVProgressHUD showErrorWithStatus:@"不是一个网页"];
//                }
//            };
//            [weakSelf presentViewController:vc animated:YES completion:nil];
//        });
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
        
            WBQRCodeVC *vc = [[WBQRCodeVC alloc] init];
            vc.sendStrBlock = ^(NSString *str) {
                if ([str hasPrefix:@"http"]) {
                    [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"不是一个网页"];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
            
            
        });
        
        
        
    }else if (index == 2){
        //关于我们
        NSString * str = @"http://www.movida-italy.com/app/about.asp";

        NSString *encodedString=[[NSString stringWithFormat:@"%@",str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];

    }else if (index == 3){
        //分享
//        [self shareWithSetPreDefinePlatforms:nil withArr:nil];

//        NSArray * arr =@[];
//        NSLog(@"%@",arr[1]);

    }else if (index == 4){

        [self.webView reload];
    }else if (index == 5){
        
  
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
        
    }
    
    
}






/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self presentViewController:scanVC animated:YES completion:nil];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}



@end
