//
//  AvatarHomeViewController.m
//  BeautyDemo
//
//  Created by chavezchen on 2022/8/19.
//

#import "AvatarHomeViewController.h"
#import "AvatarViewController.h"
#import "SelectGenderViewController.h"
#import <XMagic/XMagic.h>
#import <XMagic/TELicenseCheck.h>
#import "../Tool/UIView+Toast.h"

@interface AvatarHomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *faceImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bodyImageV;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@end

@implementation AvatarHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceClick)];
    [_faceImageV addGestureRecognizer:faceTap];
    
    UITapGestureRecognizer *bodyeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyClick)];
    [_bodyImageV addGestureRecognizer:bodyeTap];
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
    [_photoImageV addGestureRecognizer:photoTap];
    
    _titleLb.text = NSLocalizedString(@"avatar_launch_title",nil);
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    label.text = curVersion;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    label.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame), 30);
}

- (void)faceClick {
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

- (void)bodyClick {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"功能开发中" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alert show];
    return;
}

- (void)photoClick {

    /* iOS10国行机第一次安装App时会有一个权限弹框弹出，在允许之前是没有网络的。所以可能在HomeViewController里面的license请求由于没网导致鉴权失败，这里网络请求鉴权一次。
     */
    [TELicenseCheck setTELicense:kTELinceseUrl key:kTELinceseKey completion:^(NSInteger authresult, NSString * _Nonnull errorMsg) {
        if (authresult != 0) {
            [self.view makeToast:errorMsg duration:3.0 position:CSToastPositionCenter];
            return;
        }
        NSLog(@"----------result: %zd  %@",authresult,errorMsg);
        SelectGenderViewController *viewcontrol = [[SelectGenderViewController alloc] init];
        viewcontrol.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:viewcontrol animated:YES completion:nil];
    }];
    
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
