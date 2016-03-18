//
//  ViewController.m
//  IECDemo
//
//  Created by Alex on 16/1/21.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "IceClientUtil.h"
#import <SystemManageService.h>

@interface ViewController ()
{
    id<ICECommunicator> communicator;  //Ice连接器
    id<systemmanageSystemManageServicePrx> systemManageServicePrx;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[IceClientUtil sharedInstance]getServicePrx:@"SystemManageService" class:[systemmanageSystemManageServicePrx class] prxBlock:^(ICEObjectPrx *proxy) {
        systemManageServicePrx = (systemmanageSystemManageServicePrx *)proxy;
        if ([systemManageServicePrx isKindOfClass:[systemmanageSystemManageServicePrx class]]) {
            
            systemmanageSystemConfigIceModule *model = [[systemmanageSystemConfigIceModule alloc]init];
            model.code = @"activityType";
            systemmanageSystemConfigParam *pram = [[systemmanageSystemConfigParam alloc]init];
            pram.systemConfigIceModule = model;
            systemmanageSystemConfigResult *result = [systemManageServicePrx getSystemConfigByCode:pram];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:[NSString stringWithFormat:@"%lld,%@",result.status,result.message]];
            });
            
        }else if ([systemManageServicePrx isKindOfClass:[ICEEndpointParseException class]]) {
            ICEException * ex = (ICEException *)systemManageServicePrx;
            NSString* s = [NSString stringWithFormat:@"Invalid router: %@", ex.reason];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:s];
            });
        }else if ([systemManageServicePrx isKindOfClass:[ICEException class]]) {
            NSException * ex = (NSException *)systemManageServicePrx;
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:[ex description]];
            });
        }else if ([systemManageServicePrx isKindOfClass:[NSException class]]) {
            NSException * ex = (NSException *)systemManageServicePrx;
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self exception:[ex description]];
            });
        }

    }];
}

-(void)exception:(NSString*)s {
    
    UIApplication* app = [UIApplication sharedApplication];
    if(app.applicationState != UIApplicationStateBackground) {
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:s
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
