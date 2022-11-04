//
//  ViewController.m
//  SmartAvatar
//
//  Created by Mariko0Oo on 2022/11/1.
//

#import "ViewController.h"
#import <XMagic/TELicenseCheck.h>
#import "AvatarViewController.h"
#import "UIView+Toast.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)faceClick:(UIButton *)sender {
    /* iOS10国行机第一次安装App时会有一个权限弹框弹出，在允许之前是没有网络的。所以可能在HomeViewController里面的license请求由于没网导致鉴权失败，这里再网络请求鉴权一次。
     */
    [self.view makeToast:NSLocalizedString(@"avatar_loading",nil) duration:1.5 position:CSToastPositionCenter];
    [TELicenseCheck setTELicense:kTELinceseUrl key:kTELinceseKey completion:^(NSInteger authresult, NSString * _Nonnull errorMsg) {
        if (authresult != 0) {
            [self.view makeToast:errorMsg duration:3.0 position:CSToastPositionCenter];
            return;
        }
        NSLog(@"----------result: %zd  %@",authresult,errorMsg);
        AvatarViewController *avatarVC = [[AvatarViewController alloc] init];
        avatarVC.modalPresentationStyle = UIModalPresentationFullScreen;
        avatarVC.currentDebugProcessType = AvatarPixelData;
        [self presentViewController:avatarVC animated:YES completion:nil];
    }];
}


@end
