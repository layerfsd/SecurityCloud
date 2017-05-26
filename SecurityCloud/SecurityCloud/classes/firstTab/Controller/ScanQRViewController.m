//
//  ScanQRViewController.m
//  SecurityCloud
//
//  Created by hsgene_xu on 2017/5/26.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "ScanQRViewController.h"
#import "MTBBarcodeScanner.h"
#import "LBXScanView.h"
#import "LBXScanPermissions.h"
@interface ScanQRViewController ()
@property (nonatomic,strong) MTBBarcodeScanner *scanner;

@property (nonatomic,strong) LBXScanView* qRScanView;
@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]
                                                          previewView:self.view];
    __weak __typeof(self) weakSelf = self;
    self.scanner.didStartScanningBlock = ^{
        weakSelf.scanner.scanRect = [LBXScanView getScanRectWithPreView:weakSelf.view];
    };
    // Do any additional setup after loading the view.
}

- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect];
        
        [self.view addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawScanView];
    
    //不延时，可能会导致界面黑屏并卡住一会
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
    
}


- (void)startScan
{
    if ( ![LBXScanPermissions cameraPemission] )
    {
        [_qRScanView stopDeviceReadying];
        [SVProgressHUD showInfoWithStatus:@"请到设置隐私中开启本程序相机权限"];
        return;
    }
    
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;


    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [weakSelf.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
             
                [SVProgressHUD showInfoWithStatus:code.stringValue];
                [weakSelf.scanner stopScanning];
                [weakSelf.qRScanView startScanAnimation];
            } error:&error];
            
        } else {
            // The user denied access to the camera
        }
    }];

    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];

    
    self.view.backgroundColor = [UIColor clearColor];
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
