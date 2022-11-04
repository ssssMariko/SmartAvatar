//
//  TakePhotoViewController.m
//  BeautyDemo
//
//  Created by tao yue on 2022/8/9.
//

#import "TakePhotoViewController.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <XMagic/XMagic.h>
#import "AvatarViewController.h"
#import "../Tool/UIView+Toast.h"
#import "../DataSource/AvatarResManager.h"

// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@interface TakePhotoViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIImageView *bgImageView;//背景
@property(nonatomic,strong) UIImageView *dottedLineImageView;//背景
@property(nonatomic,strong) UIButton *backBtn; // 屏幕上方最右边返回按钮
@property(nonatomic,strong) UILabel *titleLabel; //标题label
@property(nonatomic,strong) UILabel *hintLabel; //提示label
@property(nonatomic,strong) UILabel *tipsLabel; //描述label
@property (strong, nonatomic) UIView *uiView;
@property CMSampleBufferRef cur;
@property CVImageBufferRef curbuffer;
@property bool catch;
@property bool flip;
@property (nonatomic,strong) UIImageView *imgview;
@property (nonatomic,strong) AVSampleBufferDisplayLayer *previewLayer;
// Camera related
@property(nonatomic, strong) AVCaptureDevice *cameraDevice;
@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic,strong) UIButton *photoBtn;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *flipBtn;

@end

int g_width = 0;
int g_height = 0;
int g_pitch = 0;
@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUi];
//    _imgview = [[UIImageView alloc]init];
//       _imgview.frame =CGRectMake(0, 400, 100, 100);
//       [self.view addSubview:_imgview];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
    [self buildCamera:AVCaptureDevicePositionFront];
}

- (void)initUi{
    self.view.backgroundColor = [UIColor blackColor];
    
    self.previewLayer = [AVSampleBufferDisplayLayer layer];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self updatePreviewLayer];
    
    [self addArc:CGRectMake((float)(ScreenWidth - 302.5)/2,139,302.5, 362.5)];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(27.45);
        make.top.mas_equalTo(self.view).offset(59.37);
        make.height.width.mas_equalTo(22);
    }];
    
    [self.view addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(565);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
//        make.left.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(24);
    }];
    
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hintLabel.mas_bottom).offset(6);
//        make.left.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
//        make.height.mas_equalTo(18);
    }];
    

    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-72);
        make.height.width.mas_equalTo(72);
    }];
    
    [self.view addSubview:self.photoBtn];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.confirmBtn.mas_left).offset(-50);
        make.centerY.mas_equalTo(self.confirmBtn);
        make.height.width.mas_equalTo(30);
    }];

    [self.view addSubview:self.flipBtn];
    [self.flipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.confirmBtn.mas_right).offset(50);
        make.centerY.mas_equalTo(self.confirmBtn);
        make.height.width.mas_equalTo(30);
    }];
    
    
}

- (void)updatePreviewLayer {
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGSize previewSize = CGSizeMake(1080, 1920);
    if (UIInterfaceOrientationLandscapeRight == uiOrientation) {
        self.previewLayer.transform = CATransform3DMakeRotation(270.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
        previewSize = CGSizeMake(previewSize.height, previewSize.width);
    } else if (UIInterfaceOrientationLandscapeLeft == uiOrientation) {
        self.previewLayer.transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
        previewSize = CGSizeMake(previewSize.height, previewSize.width);
    }
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenRatio = screenBounds.size.width / screenBounds.size.height;
    CGFloat previewRatio = previewSize.width / previewSize.height;
    if (screenRatio > previewRatio) {
        CGFloat previewWidth = screenBounds.size.width * (previewRatio / screenRatio);
        self.previewLayer.frame = CGRectMake(screenBounds.origin.x + (screenBounds.size.width - previewWidth) / 2.0, 0, previewWidth, screenBounds.size.height);
    } else {
        CGFloat previewHeight = screenBounds.size.height * (screenRatio / previewRatio);
        self.previewLayer.frame = CGRectMake(0, screenBounds.origin.y + (screenBounds.size.height - previewHeight) / 2.0, screenBounds.size.width, previewHeight);
    }
    self.previewLayer.contentsScale = previewSize.width / self.previewLayer.frame.size.width;
}

- (void)buildCamera:(AVCaptureDevicePosition)cameraPosition {
    if (![self checkCameraAuthorization]) {
        return;
    }
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            // 设置摄像头翻转
            NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *cameraDevice in cameraDevices) {
                self.cameraDevice = cameraDevice;
                if (cameraDevice.position == cameraPosition) {
                    break;
                }
            }
            AVCaptureSession *cameraCaptureSession = [[AVCaptureSession alloc] init];
          
            [cameraCaptureSession beginConfiguration];
            cameraCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
            
            AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.cameraDevice error:nil];
            if ([cameraCaptureSession canAddInput:cameraInput]) {
                [cameraCaptureSession addInput:cameraInput];
            }
            
            // VideoDataOutput
            dispatch_queue_t videoDataQueue = dispatch_queue_create("com.tencent.youtu.videodata", NULL);
            self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
            self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
            self.videoDataOutput.videoSettings = @{(id) kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
            [self.videoDataOutput setSampleBufferDelegate:self queue:videoDataQueue];
            
            //设置帧率到30FPS
            int desiredFrameRate = 30;
            AVCaptureDeviceFormat *desiredFormat = nil;
            for ( AVCaptureDeviceFormat *format in [self.cameraDevice formats] ) {
              for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
                  if ( self.cameraDevice.activeFormat == format && range.maxFrameRate >= desiredFrameRate && range.minFrameRate <= desiredFrameRate ) {
                      desiredFormat = format;
                      break;
                  }
              }
              if (desiredFormat != nil) {
                  break;
              }
            }
            if ( desiredFormat ) {
              if ( [self.cameraDevice lockForConfiguration:NULL] == YES ) {
                  self.cameraDevice.activeVideoMinFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                  self.cameraDevice.activeVideoMaxFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                  [self.cameraDevice unlockForConfiguration];
              }
            }
            
        
            if ([cameraCaptureSession canAddOutput:self.videoDataOutput]) {
                [cameraCaptureSession addOutput:self.videoDataOutput];
            }
            cameraCaptureSession.usesApplicationAudioSession = YES;
            cameraCaptureSession.automaticallyConfiguresApplicationAudioSession = NO;
            [cameraCaptureSession commitConfiguration];
            for (AVCaptureOutput *output in cameraCaptureSession.outputs) {
                for (AVCaptureConnection *connection in output.connections) {
                    if (connection.isVideoOrientationSupported) {
                        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                    }
                    if (connection.isVideoMirroringSupported) {
                        connection.videoMirrored = cameraPosition == AVCaptureDevicePositionFront;
                    }
                }
            }
            if (cameraCaptureSession.inputs.count > 0 && cameraCaptureSession.outputs.count > 0) {
                [cameraCaptureSession startRunning];
            }
            self.captureSession = cameraCaptureSession;
        }
    }];
}

- (BOOL)checkCameraAuthorization {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"“Youtu”想访问您的相机"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"不允许"
                                                     otherButtonTitles:@"好", nil];
            [alerView show];
        });
        return NO;
    }
    return YES;
}

- (void)onBack:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)flipCamera:(id)sender {
    if (self.flip) {
        [self buildCamera:AVCaptureDevicePositionFront];
        self.flip = NO;
    }else{
        [self buildCamera:AVCaptureDevicePositionBack];
        self.flip = YES;
    }
}

- (void)catchPhoto:(id)sender {
    self.catch = YES;
}

- (void)selectPhoto:(id)sender{
    [self openImagePicker];
}

-(void)openImagePicker{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =@[(NSString*)kUTTypeImage];
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"生成虚拟头像";
    }
    return _titleLabel;
}

- (void)addArc:(CGRect)viewSize {
    //中间镂空的椭圆框
//    CGRect myRect =CGRectMake(36,138,302.5, 362.5);
    CGRect myRect =viewSize;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    //虚线
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = circlePath.CGPath;
    borderLayer.lineDashPattern = @[ @8 , @8];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithRed:0 green:0.435 blue:1 alpha:1].CGColor;
    borderLayer.lineWidth = 5;
    [self.view.layer addSublayer:borderLayer];
 
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.9;
    [self.view.layer addSublayer:fillLayer];

}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takephoto_bg"]];
    }
    return _bgImageView;
}

- (UIImageView *)dottedLineImageView{
    if (!_dottedLineImageView) {
        _dottedLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotted_line"]];
    }
    return _dottedLineImageView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:16];
        _hintLabel.textColor = [UIColor colorWithRed:0.154 green:0.899 blue:1 alpha:1];
        _hintLabel.numberOfLines = 0;
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = NSLocalizedString(@"avatar_capture_main_tip",nil);
    }
    return _hintLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [UIColor colorWithRed:0.62 green:0.655 blue:0.725 alpha:1];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = NSLocalizedString(@"avatar_capture_sub_tip",nil);
    }
    return _tipsLabel;
}

- (UIButton *)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
        [_photoBtn setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setImage:[UIImage imageNamed:@"capture_icon.png"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(catchPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)flipBtn{
    if (!_flipBtn) {
        _flipBtn = [[UIButton alloc] init];
        [_flipBtn setImage:[UIImage imageNamed:@"flip.png"] forState:UIControlStateNormal];
        [_flipBtn addTarget:self action:@selector(flipCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flipBtn;
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer:(unsigned char**) pBGRA
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    g_width = width;
    g_height = height;
    g_pitch = bytesPerRow;
    //return (unsigned char*)baseAddress;
    *pBGRA = (unsigned char*)malloc(g_pitch*g_height);
    memcpy(*pBGRA, baseAddress, g_pitch*g_height);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //   unsigned char* pBGRA = CGBitmapContextGetData(context);
    //   return pBGRA;
    
    
    
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}


#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
// 在摄像头回调传入帧数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    self.curbuffer = pixelBuffer;
    self.cur = sampleBuffer;
    [self.previewLayer enqueueSampleBuffer:sampleBuffer];
    if (self.catch) {
        //通过抽样缓存数据创建一个UIImage对象
           unsigned char* pBGRA = NULL;
           UIImage* image = [self imageFromSampleBuffer:sampleBuffer:&pBGRA];//最开始一帧图像很暗，后面就正常了
           dispatch_async(dispatch_get_main_queue(), ^{
               // 回到主线程 image为捕捉到的画面，直接使用就OK了
//               self.imgview.image = image;
               [self createAvatarWithPhoto:image];
               self.catch = NO;
           });
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 移除相册界面
    int errorCode = 0;
    [picker.view removeFromSuperview];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 回到主线程 image为捕捉到的画面，直接使用就OK了
//        self.imgview.image = image;
        [self createAvatarWithPhoto:image];
        self.catch = NO;
    });
}

- (void)stopUpdatingView
{
    // 暂停摄像头
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)resumeUpdatingView
{
    //恢复摄像头
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

#pragma mark - VC life cycle

// 退后台停止渲染
- (void)viewWillResignActive:(NSNotification *)noti {
    [self stopUpdatingView];
}

// 后台返回恢复动效
- (void)viewDidBecomeActive:(NSNotification *)noti {
    [self resumeUpdatingView];
}

#pragma mark - 拍照捏脸
- (void)createAvatarWithPhoto:(UIImage *)image
{
    [self stopUpdatingView];
        
    NSString *path = NSTemporaryDirectory();
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatarPhoto.png"];
    BOOL ret = [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    if (!ret) {
        return;
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    
    AvatarResManager *resManager = [[AvatarResManager alloc] init];
    
    AvatarGender gender = self.isMale ? AvatarGenderMale : AvatarGenderFemale;
    NSString *resPath = [resManager avatarResPath:gender];

    [XMagic createAvatarByPhoto:imagePath avatarResPaths:@[resPath] isMale:self.isMale success:^(NSString * _Nullable matchedResPath, NSString * _Nullable srcData) {
        [self.view hideToastActivity];
        AvatarViewController *avatarVC = [[AvatarViewController alloc] init];
        avatarVC.currentDebugProcessType = AvatarPixelData;
        avatarVC.photoGender = self.isMale ? AvatarGenderMale : AvatarGenderFemale;
        avatarVC.photoAvatarSrc = srcData;
        avatarVC.photoAvatarResPath = matchedResPath;
        avatarVC.showType = AvatarShowTypePhoto;
        avatarVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self dismissViewControllerAnimated:NO completion:nil];
        [[self.class getCurrentVC] presentViewController:avatarVC animated:YES completion:nil];

    } failure:^(NSInteger code, NSString * _Nullable msg) {
        [self.view hideToastActivity];
        [self.view makeToast:msg duration:3.0 position:CSToastPositionCenter];
        [self resumeUpdatingView];
//        self.catch = YES;
    }];
}

- (void)dealloc
{
//    self.captureSession = nil;
}


+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
