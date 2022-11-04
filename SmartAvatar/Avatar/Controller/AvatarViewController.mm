//
//  AvatarViewController.m
//  BeautyDemo
//
//  Created by chavezchen on 2022/8/10.
//

#import "AvatarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <XMagic/XMagic.h>
#import <Masonry/Masonry.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "../View/AvatarPanelView.h"
#import <AFNetworking/AFNetworking.h>
#import <SSZipArchive/SSZipArchive.h>
#import "../Tool/UIView+Toast.h"

static CGFloat const kPreviewWidth = 1080.0f;
static CGFloat const kPreviewHeight = 1440.0f;
static CGFloat const kButtonWidth = 40.0f;

@interface AvatarViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, YTSDKEventListener, YTSDKLogListener, UIGestureRecognizerDelegate,UIAlertViewDelegate,AvatarPanelProtocol>
{
    //OpenGL related
    CVOpenGLESTextureRef bgraTextureRef;
    CVOpenGLESTextureCacheRef textureCache;
    EAGLContext* eaglContext;
    GLuint glFrameBuffer;
    CVPixelBufferRef pixelBufferOuput;
    NSTimer *tipsTimer;
}

@property (nonatomic,strong) AVSampleBufferDisplayLayer *previewLayer;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *genderBtn;
@property (nonatomic, strong) UILabel *tipsLabel; // 提示信息
@property (nonatomic, weak) AvatarPanelView *panelView;
@property (nonatomic, strong) UIButton *bgExchangeBtn; // 虚拟背景切换
@property (nonatomic, strong) AvatarResManager *resManager;
// Camera related
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

// SDK related
@property (nonatomic, strong) XMagic *beautyKit;

@property (nonatomic, copy) NSArray *panelData;
@property (nonatomic, assign) BOOL isTemplateLoaded;
@end

@implementation AvatarViewController
{
    dispatch_queue_t _serialQueue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        
    _serialQueue = dispatch_queue_create("tx.avatar.serial.queue", DISPATCH_QUEUE_SERIAL);
    [self setupResManager];
    [self buildUI];
    [self buildBeautySDK];
    if (_currentDebugProcessType == AvatarTextureData) {
        [self setupGlEnv];
    }
    [self loadPanelData];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];

    [self buildCamera:AVCaptureDevicePositionFront];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resumeUpdatingView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self stopUpdatingView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)stopUpdatingView
{
    // 暂停摄像头
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
    
    [self.beautyKit onPause];
}

- (void)resumeUpdatingView
{
    //恢复摄像头
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
    
    [self.beautyKit onResume];
}

- (void)setupResManager
{
    self.resManager.showType = self.showType;
    // 如果是从拍照进来的，需要设置对应属性
    if (self.showType == AvatarShowTypePhoto) {
        self.resManager.photoAvatarSrc = self.photoAvatarSrc;
        self.resManager.photoAvatarSrcGender = self.photoGender;
        self.resManager.photoAvatarResPath = self.photoAvatarResPath;
    }
}

- (void)buildBeautySDK {
    
    CGSize previewSize = CGSizeMake(kPreviewWidth, kPreviewHeight);
    NSString *beautyConfigPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    beautyConfigPath = [beautyConfigPath stringByAppendingPathComponent:@"beauty_config.json"];
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    BOOL isDir = YES;
    NSDictionary * beautyConfigJson = @{};
    if ([localFileManager fileExistsAtPath:beautyConfigPath isDirectory:&isDir] && !isDir) {
        NSString *beautyConfigJsonStr = [NSString stringWithContentsOfFile:beautyConfigPath encoding:NSUTF8StringEncoding error:nil];
        NSError *jsonError;
        NSData *objectData = [beautyConfigJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        beautyConfigJson = [NSJSONSerialization JSONObjectWithData:objectData                                                           options:NSJSONReadingMutableContainers
                                                                 error:&jsonError];
    }
    NSDictionary *assetsDict = @{@"core_name":@"LightCore.bundle",
                                 @"root_path":[[NSBundle mainBundle] bundlePath],
                                 @"tnn_"
                                 @"beauty_config":beautyConfigJson
    };
    // Init beauty kit
    self.beautyKit = [[XMagic alloc] initWithRenderSize:previewSize assetsDict:assetsDict];
    // Register log
    [self.beautyKit registerSDKEventListener:self];
    [self.beautyKit registerLoggerListener:self withDefaultLevel:YT_SDK_ERROR_LEVEL];
    [self.beautyKit setFeatureEnableDisable:ANIMOJI_52_EXPRESSION enable:YES];
    // 设置avatar默认模版
//    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *bundlePath = [self.resManager avatarResPath:gender];
//        [self.beautyKit loadAvatar:bundlePath exportedAvatar:nil completion:nil];
//    });
    
}

- (void)loadAvatarTemplateIfNeed
{
    if (_isTemplateLoaded) {
        return;
    }
    _isTemplateLoaded = YES;
    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
    BOOL isVirtual = self.bgExchangeBtn.isSelected;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AvatarData *bgPnaleConfig = [self.resManager getBackGroudPanel:isVirtual gender:gender];
        // 设置avatar模版
        NSString *bundlePath = [self.resManager avatarResPath:gender];
        NSString *savedConfig = [self.resManager getSavedAvatarConfigs:gender];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.beautyKit loadAvatar:bundlePath exportedAvatar:savedConfig completion:^(BOOL success, NSArray<AvatarData *> * _Nullable invalidAvatarList) {
                if (!success) {
                    NSLog(@"有素材缺失，请检查。。。");
                }
            }];
            // 开启无人脸时静止闭眼状态
            [self enableAvatarIdleExpression:YES];
            // 同步男女切换时的背景状态
            [self.beautyKit updateAvatar:@[bgPnaleConfig] completion:nil];
        });
    });
}

- (void)enableAvatarIdleExpression:(BOOL)enable
{
    // 也可以直接写json字符串 @"{\"enable\" : true}"
    NSDictionary *value = @{@"enable" : @(enable)};
    NSData *valueData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
    NSString *valueString = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
    [self.beautyKit sendCustomEvent:ENABLE_AVATAR_IDLE_EXPRESSION eventValue:valueString];
}


- (void)loadPanelData
{
    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 设置数据
        self.panelData = [self.resManager getPanelData:gender];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.panelView setupDataSource:self.panelData];
            [self.view hideToastActivity];
//            [self resumeUpdatingView];
//            [self.beautyKit onResume];
        });
    });
    
}

- (void)setupGlEnv{
    //gl上下文使用beautyKit的
    eaglContext = [self.beautyKit getCurrentGlContext];
    [EAGLContext setCurrentContext: eaglContext];
    CVReturn res = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, eaglContext, NULL, &textureCache);
    if (res != kCVReturnSuccess) {
        NSLog(@"Create textureCache failed");
        return ;
    }
    //framebuffer 创建
    glGenFramebuffers(1, &glFrameBuffer);
    pixelBufferOuput = NULL;
}


- (void)buildUI
{
    self.view.backgroundColor = [UIColor blackColor];
    // Add preview layer
    self.previewLayer = [AVSampleBufferDisplayLayer layer];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self updatePreviewLayer];
    
    CGFloat statusH = 0;
    if (@available(iOS 11.0, *)) {
        statusH = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    }
    //返回按钮
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20+statusH);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setImage:[UIImage imageNamed:@"export"] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(exportAndSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20+statusH);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.font = [UIFont systemFontOfSize:20.0];
    self.tipsLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
    }];
    
    
    AvatarPanelView *panelView = [[AvatarPanelView alloc] init];
    [self.view addSubview:panelView];
    self.panelView = panelView;
    self.panelView.delegate = self;
    [panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(CGRectGetHeight(self.previewLayer.frame) + statusH);
    }];
    
    
    self.genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.genderBtn setImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
    [self.genderBtn setImage:[UIImage imageNamed:@"female"] forState:UIControlStateSelected];
    [self.genderBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchUpInside];
    self.genderBtn.backgroundColor = [UIColor whiteColor];
    self.genderBtn.layer.cornerRadius = 20;
    self.genderBtn.clipsToBounds = YES;
//    self.genderBtn.selected = YES;
    [self.view addSubview:self.genderBtn];
    [self.genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.bottom.mas_equalTo(panelView.mas_top).mas_offset(-100);
    }];
    
    self.bgExchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgExchangeBtn setImage:[UIImage imageNamed:@"bgExchange"] forState:UIControlStateNormal];
    [self.bgExchangeBtn setImage:[UIImage imageNamed:@"bgExchange"] forState:UIControlStateSelected];
    [self.bgExchangeBtn addTarget:self action:@selector(bgExchangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bgExchangeBtn];
    [self.bgExchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kButtonWidth);
        make.bottom.mas_equalTo(panelView.mas_top).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(20);
    }];
    
    // 拍照类型
    if (self.showType == AvatarShowTypePhoto) {
        self.genderBtn.selected = self.photoGender == AvatarGenderFemale;
        self.genderBtn.hidden = YES;
    }
    
    
}

- (void)updatePreviewLayer {
    
    CGFloat statusH = 0;
    if (@available(iOS 11.0, *)) {
        statusH = [UIApplication sharedApplication].windows[0].safeAreaInsets.top;
    }
    
    UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize previewSize = CGSizeMake(kPreviewWidth, kPreviewHeight);
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
        self.previewLayer.frame = CGRectMake(screenBounds.origin.x + (screenBounds.size.width - previewWidth) / 2.0, statusH, previewWidth, screenBounds.size.height);
    } else {
        CGFloat previewHeight = screenBounds.size.height * (screenRatio / previewRatio);
        self.previewLayer.frame = CGRectMake(0, statusH, screenBounds.size.width, previewHeight);
    }
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

            
            AVCaptureDeviceFormat *bestFormat;
            for (AVCaptureDeviceFormat *format in self.cameraDevice.formats) {
                CMVideoDimensions dimens = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
                if (dimens.width == kPreviewHeight && dimens.height == kPreviewWidth) {
                    bestFormat = format;
                    break;;
                }
            }
            // 设置自定义分辨率
            if ([self.cameraDevice lockForConfiguration:nil]) {
                self.cameraDevice.activeVideoMinFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                self.cameraDevice.activeVideoMaxFrameDuration = CMTimeMake ( 1, desiredFrameRate );
                self.cameraDevice.activeFormat = bestFormat;
                [self.cameraDevice unlockForConfiguration];
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
                        connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                    }
                    if (connection.isVideoMirroringSupported) {
                        connection.videoMirrored = cameraPosition == AVCaptureDevicePositionBack;
                    }
                    [connection setVideoScaleAndCropFactor:1.0];
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

- (AvatarResManager *)resManager
{
    @synchronized (self) {
        if (!_resManager) {
            _resManager = [[AvatarResManager alloc] init];
        }
        return _resManager;
    }
}

#pragma mark - UIButton action
- (void)onBack:(id)sender {
    [self.beautyKit clearListeners];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)exportAndSaveClick:(UIButton *)btn
{
//    [self loadAvatarTemplateIfNeed];
    // 写入可能会耗时，放子线程
    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL ret = [self.resManager saveSelectedAvatarConfigs:gender];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ret) {
                NSLog(@"-------- 保存成功");
                [self.view makeToast:@"保存成功" duration:1.5 position:CSToastPositionCenter];
            } else {
                NSLog(@"-------- 保存失败");
                [self.view makeToast:@"保存失败" duration:1.5 position:CSToastPositionCenter];
            }
        });
    });
}

- (void)genderClick:(UIButton *)btn
{
//    [self stopUpdatingView];
    // 真实背景下切换性别 做一些体验上的优化调整
    if (self.bgExchangeBtn.isSelected) {
        [self.beautyKit onPause];
        [self.beautyKit loadAvatar:nil exportedAvatar:nil completion:nil];
    }
    
    btn.selected = !btn.isSelected;
    [self.view makeToastActivity:CSToastPositionCenter];
    self.isTemplateLoaded = NO;
//    self.resManager = nil;
//    [self loadAvatarTemplateIfNeed];
    [self loadPanelData];
}

- (void)bgExchangeClick:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
    AvatarData *selConfig = [self.resManager getBackGroudPanel:btn.isSelected gender:gender];
    [self.beautyKit updateAvatar:@[selConfig] completion:nil];
}

- (void)onTipsHide:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.tipsLabel.hidden = YES;
    });
}

#pragma mark - AvatarPanelProtocol
- (void)avatarPanelItemUpdate:(AvatarSelectedInfo *)info avatarData:(AvatarData *)selAvatar
{
    NSDictionary *avatarDict = self.resManager.getMaleAvatarData;
    if (self.genderBtn.isSelected) {
        avatarDict = self.resManager.getFemaleAvatarData;
    }
    dispatch_async(_serialQueue, ^{
        // 根据relatedCategory找到关联的category进行同步，比如选择发型配置，会将发色也变成发型对应的发色，这里需要将之前的发色重新设置回来。
        NSMutableArray *avatars = [NSMutableArray array];
        if (info.relatedCategory) {
            NSArray *relatedArray = avatarDict[info.relatedCategory];
            for (AvatarData *config in relatedArray) {
                if (config.isSelected) {
                    [avatars addObject:config];
                    break;
                }
            }
        }
        
        // 根据绑定的类型，找到对应的AvatarData进行设置，比如选择肤色，脖子的颜色也需要同步改成一样的颜色
        if (info.bindData) {
            for (NSDictionary *bindDict in info.bindData) {
                NSString *bindCategory = bindDict[@"category"];
                NSString *bindId = bindDict[@"id"];
                if (!bindCategory || !bindId) {
                    continue;
                }
                NSArray *bindArray = avatarDict[bindCategory];
                for (AvatarData *config in bindArray) {
                    if ([config.Id isEqualToString:bindId]) {
                        [avatars addObject:config];
                        config.isSelected = YES;
                    } else {
                        config.isSelected = NO;
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // sdk素材没有对应资源，可能需要下载
            if (selAvatar) {
                [avatars insertObject:selAvatar atIndex:0];
                [self.beautyKit updateAvatar:avatars completion:nil];
            } else {
                [self downLoadResWithAvatar:info];
            }
        });
    });
    
}


- (void)downLoadResWithAvatar:(AvatarSelectedInfo *)info
{
    // 如果有下载链接，进行下载
    if (!info.downloadUrl) {
        return;
    }
    AvatarGender gender = self.genderBtn.isSelected ? AvatarGenderFemale : AvatarGenderMale;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:info.downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"==========%@",filePath);
        NSString *zipPath = [filePath path];// 将NSURL转成NSString
        BOOL ret = [SSZipArchive unzipFileAtPath:zipPath toDestination:NSTemporaryDirectory()];
        if (!ret) {
            NSLog(@"-----解压失败.");
            return;
        }
        // 解压完后删除zip包
        [[NSFileManager defaultManager] removeItemAtPath:zipPath error:nil];
        
        NSString *fileName = [response.suggestedFilename stringByDeletingPathExtension];
        NSString *oriPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSString *resPath = [self.resManager avatarResPath:gender];
//        if (gender == AvatarGenderMale) {
//            resPath = [resPath stringByAppendingPathComponent:@"animoji_0624"];
//        } else {
//            resPath = [resPath stringByAppendingPathComponent:@"animoji_0625"];
//        }
        
        [XMagic addAvatarResource:resPath category:info.category filePath:oriPath completion:^(NSError * _Nullable error, NSArray * _Nullable avatarList) {
//            NSLog(@"%@---%@",error,avatarList);
            // 添加完后删除原始文件
            [[NSFileManager defaultManager] removeItemAtPath:oriPath error:nil];
            if (error) {
                NSLog(@"-------error : %@",error);
                return;
            }
            // 更新素材资源
            [self.resManager updateAvatarList:info.category avatars:avatarList gender:gender];
            // 更新完后重新设置素材
            if (avatarList.count > 0) {
                for (AvatarData *avatar in avatarList) {
                    [self avatarPanelItemUpdate:info avatarData:avatar];
                }
            }
        }];
        
    }];
    [download resume];
}

- (void)avatarPanelFaceTypeChange:(AvatarSelectedInfo *)info faceItem:(AvatarItemInfo *)itemInfo
{
    NSDictionary *avatarDict = self.resManager.getMaleAvatarData;
    if (self.genderBtn.isSelected) {
        avatarDict = self.resManager.getFemaleAvatarData;
    }
    AvatarData *selConfig;
    NSArray *array = avatarDict[info.category];
    for (AvatarData *config in array) {
        if (config.type == AvatarDataTypeSelector) {
            if ([config.Id isEqualToString:info.Id]) {
                selConfig = config;
                break;
            }
        }
    }
    // 修改面板模型的数据（修改展示数据）
    [itemInfo.valueDcit setValuesForKeysWithDictionary:selConfig.value];
    
    
    // 修改sdk返回的avatar数据(修改传递给sdk的数据)
    array = avatarDict[@"face_shape_value"];
    for (AvatarData *config in array) {
        if ([config.Id isEqualToString:itemInfo.Id]) {
//            [config.value setValuesForKeysWithDictionary:selConfig.value];
            config.value = itemInfo.valueDcit.copy;
            break;
        }
    }
    
}

- (void)avatarPanelFaceShapeValueChange:(AvatarSelectedInfo *)info resetCategory:(NSString *)category
{
    NSDictionary *avatarDict = self.resManager.getMaleAvatarData;
    if (self.genderBtn.isSelected) {
        avatarDict = self.resManager.getFemaleAvatarData;
    }
    // 调整了脸型微调，取消脸型的选中状态
    NSArray *array = avatarDict[category];
    for (AvatarData *config in array) {
        config.isSelected = NO;
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 在摄像头回调传入帧数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CMFormatDescriptionRef formatRef = CMSampleBufferGetFormatDescription(sampleBuffer);
    CMMediaType mediaType = CMFormatDescriptionGetMediaType(formatRef);
    if (kCMMediaType_Video == mediaType ) {
        //get origin value
        [self mycaptureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection originImageProcess:YES];
    } else {
        [self mycaptureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection originImageProcess:NO];
    }
}

- (YTProcessOutput*)processDataWithCpuFuc:(CMSampleBufferRef)inputSampleBuffer {
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(inputSampleBuffer);
    CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(inputSampleBuffer);
    YTProcessInput *input = [[YTProcessInput alloc] init];
    input.pixelData = [[YTImagePixelData alloc] init];
    input.pixelData.data = pixelBuffer;
    input.pixelData.sampleTime = sampleTime;
    input.dataType = kYTImagePixelData;
    YTProcessOutput * output = [self.beautyKit process:input];
    input.pixelData = nil;
    input = nil;
    return output;
}

- (YTProcessOutput*)processDataWithGpuFuc:(CMSampleBufferRef)inputSampleBuffer{
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(inputSampleBuffer);
    CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(inputSampleBuffer);
    
    //Step 1: 使用CMSampleBufferRef转成texture模拟GPU输入
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    int bufferWidth = (GLsizei)CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = (GLsizei)CVPixelBufferGetHeight(pixelBuffer);
    
    [EAGLContext setCurrentContext: eaglContext];
    if(bgraTextureRef){
        CFRelease(bgraTextureRef);
        bgraTextureRef = NULL;
    }
    CVReturn res = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                    textureCache,
                                                                    pixelBuffer,
                                                                    NULL,
                                                                    GL_TEXTURE_2D,
                                                                    GL_RGBA,
                                                                    bufferWidth,
                                                                    bufferHeight,
                                                                    GL_BGRA,
                                                                    GL_UNSIGNED_BYTE,
                                                                    0,
                                                                    &bgraTextureRef);
    
    
   
    if (res) {
        NSLog(@"CVOpenGLESTextureCacheCreateTextureFromImage error at %d", res);
        return nil;
    }
    GLuint bgraTex = CVOpenGLESTextureGetName(bgraTextureRef);
    glBindTexture(GL_TEXTURE_2D, bgraTex);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    //Step 2: 按照texture方式测试接口
    YTProcessInput *input = [[YTProcessInput alloc] init];
    input.textureData = [[YTTextureData alloc] init];
    input.textureData.texture = bgraTex;
    input.textureData.textureWidth = bufferWidth;
    input.textureData.textureHeight = bufferHeight;
    input.dataType = kYTTextureData;
    YTProcessOutput * output = [self.beautyKit process:input];

    //Step 3: 将得到的texture数据转成CPU数据，复用demo的上屏逻辑查看效果
    [EAGLContext setCurrentContext: eaglContext];
    glBindFramebuffer(GL_FRAMEBUFFER, glFrameBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,  output.textureData.texture, 0);
 
    int outputTextureWidth = output.textureData.textureWidth;
    int outputTextureHeight = output.textureData.textureHeight;
    glViewport(0, 0, outputTextureWidth, outputTextureHeight);

    YTProcessOutput *outputCpu = [[YTProcessOutput alloc] init];
    outputCpu.pixelData = [[YTImagePixelData alloc] init];
    outputCpu.pixelData.data = NULL;
    outputCpu.pixelData.sampleTime = sampleTime;
    NSDictionary *pixelBufferAttributes = @{
                                            (NSString *)kCVPixelBufferIOSurfacePropertiesKey: @{},
                                            (NSString *)kCVPixelBufferBytesPerRowAlignmentKey: @(64),
                                            };
    if(pixelBufferOuput){
        CFRelease(pixelBufferOuput);
        pixelBufferOuput = NULL;
    }
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, outputTextureWidth, outputTextureHeight , kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)pixelBufferAttributes, &pixelBufferOuput);

    if ((pixelBufferOuput != NULL) && (status == kCVReturnSuccess)){
        outputCpu.pixelData.data = pixelBufferOuput;
        
        unsigned char * outputPixelData = new unsigned char[outputTextureWidth * outputTextureHeight *4];
        //SDK是RGBA输入，RGBA输出，作为Pixel展示时候需要转化成BGRA，Demo直接在read时候转化
        glReadPixels(0, 0, outputTextureWidth, outputTextureHeight, GL_BGRA, GL_UNSIGNED_BYTE, outputPixelData);
        
        CVPixelBufferLockBaseAddress(outputCpu.pixelData.data, 0);
        GLubyte *pixelBufferData = (GLubyte *)CVPixelBufferGetBaseAddress(outputCpu.pixelData.data);
        //pixlBuffer会添加padding，540P bytesPerRow==2176，所以需要按行拷贝
        int bytePerRow = (int)CVPixelBufferGetBytesPerRow(outputCpu.pixelData.data);
        int stepInput = outputTextureWidth * 4;
        int stepOutput = bytePerRow;
        for (int i = 0; i < outputTextureHeight; ++i) {
            memcpy(pixelBufferData + i*stepOutput, outputPixelData + i* stepInput, stepInput);
        }
        CVPixelBufferUnlockBaseAddress(outputCpu.pixelData.data, 0);
        delete []outputPixelData;
    }
    //Step 3: GL资源重置
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    CVOpenGLESTextureCacheFlush(textureCache, 0);

    return outputCpu;
}

- (void)mycaptureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)inputSampleBuffer fromConnection:(AVCaptureConnection *)connection originImageProcess:(BOOL)originImageProcess {
    if (captureOutput == self.videoDataOutput) {
        // 处理每帧渲染信息
        YTProcessOutput *output = nil;
        if (_currentDebugProcessType == AvatarTextureData) {
            output = [self processDataWithGpuFuc:inputSampleBuffer];
        }
        else if (_currentDebugProcessType == AvatarPixelData) {
            output = [self processDataWithCpuFuc:inputSampleBuffer];
        }
        else{
            NSLog(@"_currentDebugProcessType error!");
            return ;
        }
        if (output.pixelData != nil) {
            CMSampleBufferRef outputSampleBuffer = NULL;
            CVPixelBufferRef outputPixelBuffer = output.pixelData.data;
            CFRetain(outputPixelBuffer);
            // 不设置具体时间信息
            CMSampleTimingInfo timing = {kCMTimeInvalid, kCMTimeInvalid, kCMTimeInvalid};
            // 获取视频信息
            CMVideoFormatDescriptionRef videoInfo = NULL;
            OSStatus result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, outputPixelBuffer, &videoInfo);
            NSParameterAssert(result == 0 && videoInfo != NULL);

            result = CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, outputPixelBuffer, true, NULL, NULL, videoInfo, &timing, &outputSampleBuffer);
            NSParameterAssert(result == 0 && outputSampleBuffer != NULL);
            CFRelease(outputPixelBuffer);
            CFRelease(videoInfo);

            CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(outputSampleBuffer, YES);
            CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
            CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
    
            // 这里是处理进入后台后layer失效问题
            if (self.previewLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
                [self.previewLayer flush];
            }
            if (outputSampleBuffer != NULL) {
                [self.previewLayer enqueueSampleBuffer:outputSampleBuffer];
                CFRelease(outputSampleBuffer);
            }
        }
        if (output != nil) {
            output.pixelData = nil;
            output = nil;
        }
        // 加载模板
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAvatarTemplateIfNeed];
        });
    }
}

#pragma mark - YTSDKEventListener

- (void)onYTDataEvent:(id)event
{
    NSLog(@"YTData %@", event);
}
- (void)onAIEvent:(id)event
{
    NSDictionary *eventDict = (NSDictionary *)event;
    if (eventDict[@"face_info"] != nil) {
//        NSArray *face_list = eventDict[@"face_info"];
//        NSLog(@"face count %lu", (unsigned long)face_list.count);
    } else if (eventDict[@"hand_info"] != nil) {
        NSArray *hand_list = eventDict[@"hand_info"];
        NSLog(@"hand count %lu", (unsigned long)hand_list.count);
    } else if (eventDict[@"body_info"] != nil) {
        NSArray *body_list = eventDict[@"body_info"];
        NSLog(@"body count %lu", (unsigned long)body_list.count);
    }
}
- (void)onTipsEvent:(id)event
{
    NSLog(@"tips event:%@", event);
    NSDictionary *eventDict = (NSDictionary *)event;
    __weak __typeof(self)weakSelf = self;
    if (tipsTimer != nil) {
        [tipsTimer invalidate];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if ([eventDict[@"need_show"] boolValue] == YES) {
            strongSelf.tipsLabel.hidden = NO;
            strongSelf.tipsLabel.text = eventDict[@"tips"];
            int timeCount = eventDict[@"duration"]==nil?3:([eventDict[@"duration"] intValue]/1000);
            strongSelf->tipsTimer = [NSTimer scheduledTimerWithTimeInterval:timeCount target:strongSelf selector:@selector(onTipsHide:) userInfo:nil repeats:NO];
        } else {
            strongSelf.tipsLabel.hidden = YES;
        }
    });
}
- (void)onAssetEvent:(id)event
{
    NSLog(@"asset event:%@", event);
}



#pragma mark - YTSDKLogListener

- (void)onLog:(YtSDKLoggerLevel) loggerLevel withInfo:(NSString *) logInfo
{
    NSLog(@"[%ld]-%@", (long)loggerLevel, logInfo);
}

- (void)dealloc{
    if (self.beautyKit) {
        [self.beautyKit deinit];
    }
    if(bgraTextureRef){
        CFRelease(bgraTextureRef);
    }
    if (textureCache) {
        CVOpenGLESTextureCacheFlush(textureCache, 0);
    }
    if(glFrameBuffer){
        glDeleteFramebuffers(1, &glFrameBuffer);
    }
    self.captureSession = nil;
   
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


@end
