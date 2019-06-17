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


#define SSSSBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define HHHHHH [UIScreen mainScreen].bounds.size.height
#define WWWWW [UIScreen mainScreen].bounds.size.width
#define  URLURL @"http://www.movida-italy.com/app/index.asp"


@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,weak) JSContext * context;
@property(nonatomic,strong)UIButton *settingBt;
@property(nonatomic,strong)UIView *backV;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * web =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH)];
    [self.view addSubview: web];
    self.webView = web;
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLURL]]];
    web.scrollView.bounces = NO;
    
    web.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    //    web.backgroundColor =[UIColor redColor];
    
    self.backV = [[UIView alloc] initWithFrame:CGRectMake(WWWWW - 60 - 10, HHHHHH  - 15 - 60 - 49 - 120 , 60, 180)];
    if (SSSSBarH > 20) {
        self.backV.frame = CGRectMake(WWWWW - 60 - 10, HHHHHH  - 34 - 15 - 60 - 49 - 120 , 70, 180);
        web.frame = CGRectMake(0, SSSSBarH, WWWWW, HHHHHH - SSSSBarH - 34);
    }
    [self.view addSubview:self.backV];
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
        
        zkYanPiaoVC * vc =[[zkYanPiaoVC alloc] init];
        
        [weakSelf presentViewController:vc animated:YES completion:nil];

        
    };
    

}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error) {
        NSLog(@"\nerror === %@",error.description);
    }
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



@end
