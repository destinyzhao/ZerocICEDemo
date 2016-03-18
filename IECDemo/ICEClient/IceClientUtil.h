//
//  IceClientUtil.h
//  test
//
//
//  Created by Alex on 16/1/21.
//  Copyright © 2016年 Alex. All rights reserved.
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
