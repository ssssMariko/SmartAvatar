//
//  AppDelegate.m
//  SmartAvatar
//
//  Created by Mariko0Oo on 2022/11/1.
//

#import "AppDelegate.h"
#import <XMagic/TELicenseCheck.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self testHttp];
    [TELicenseCheck setTELicense:kTELinceseUrl key:kTELinceseKey completion:^(NSInteger authresult, NSString * _Nonnull errorMsg) {
        NSLog(@"----------result: %zd  %@",authresult,errorMsg);
    }];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    self.window.rootViewController =  [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)testHttp
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",dict);
        }
    }];
    
    [dataTask resume];
}

@end
