//
//  IceClientUtil.h
//  test
//
//  Created by 邓燎燕 on 15/12/8.
//  Copyright © 2015年 邓燎燕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/Ice.h>

@protocol ICECommunicator;

typedef void (^dispatch_block)(void);
typedef void (^IcePrxBlock)(ICEObjectPrx *proxy);

@interface IceClientUtil : NSObject

//@property (copy, nonatomic) IcePrxBlock icePrxBlock;

- (id<ICECommunicator>) getICECommunicator;

- (void) closeCommunicator:(BOOL)removeServiceCache;

- (void) getServicePrx:(NSString*)serviceName class:(Class)serviceCls prxBlock:(IcePrxBlock)prxBlock;

- (void)serviceAsync:(dispatch_block)block;

+ (instancetype)sharedInstance;

@end
