//
//  IceClientUtil.m
//  test
//
//
//  Created by Alex on 16/1/21.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "IceClientUtil.h"

const static NSString * locatorKey = @"Ice.Locator";

@interface IceClientUtil ()

@property (copy, nonatomic)NSString *iceLocatorValue;
@property (strong, nonatomic) id<ICECommunicator> communicator; //Ice连接器
@property (strong, nonatomic) NSMutableDictionary *cls2PrxMap;
@property (assign, nonatomic) NSInteger lastAccessTimestamp;
@property (assign, nonatomic) int idleTimeOutSeconds; // 超时
@property (strong, nonatomic) NSThread *monitorThread;
@property (assign, nonatomic) BOOL stoped;

@end

@implementation IceClientUtil

+ (instancetype)sharedInstance
{
    static IceClientUtil *_iceClientUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_iceClientUtil == nil) {
            _iceClientUtil = [[IceClientUtil alloc]init];
        }
    });
    return _iceClientUtil;
}

- (instancetype)init
{
    self  = [super init];
    if (self) {
        [self getICECommunicator];
    }
    return self;
}

/**
 *  初始化ICE连接器
 *
 *  @return ICECommunicator
 */
- (id<ICECommunicator>) getICECommunicator{

    if (_communicator == nil) {
        if (_iceLocatorValue == nil) {
            NSString * plistPath = [[ NSBundle mainBundle] pathForResource:@"iceClient" ofType:@"plist"];
            NSDictionary * plist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            _iceLocatorValue = [plist objectForKey:locatorKey];
            _idleTimeOutSeconds = [[plist objectForKey:@"idleTimeOutSeconds"] intValue];
            NSLog(@"Ice client`s locator is %@ proxy cache time out seconds :%d",_iceLocatorValue,_idleTimeOutSeconds);
        }
        
        ICEInitializationData* initData = [ICEInitializationData initializationData];
        initData.properties = [ICEUtil createProperties];
        [initData.properties setProperty:@"Ice.Default.Locator" value:_iceLocatorValue];
        initData.dispatcher = ^(id<ICEDispatcherCall> call, id<ICEConnection> con)
        {
            dispatch_sync(dispatch_get_main_queue(), ^ { [call run]; });
        };
        //NSAssert(communicator == nil, @"communicator == nil");
        _communicator = [ICEUtil createCommunicator:initData];
        [self createMonitoerThread];
    }
    _lastAccessTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
    return _communicator;
}

/**
 *  释放ICE连接器
 *
 *  @param removeServiceCache
 */
- (void) closeCommunicator:(BOOL)removeServiceCache{
    if(_communicator != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            if (_communicator != nil) {
                [self safeShutdown];
                _stoped = YES;
                if(removeServiceCache && _cls2PrxMap!=nil && [_cls2PrxMap count]!=0){
                    [_cls2PrxMap removeAllObjects];
                }
            }
        });
    }
}

-(void) safeShutdown{
    @try{
        [_communicator shutdown];
    }
    @catch(ICEException* ex)
    {
    }
    @finally{
        [_communicator destroy];
        _communicator = nil;
    }
}

- (void)serviceAsync:(dispatch_block)block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        block();
    });
}

/**
 *  获取服务代理实例
 *
 *  @param serviceName
 *  @param serviceCls
 *
 *  @return ICEObjectPrx
 */
- (void)getServicePrx:(NSString*)serviceName class:(Class)serviceCls prxBlock:(IcePrxBlock)prxBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        id<ICEObjectPrx> proxy = [_cls2PrxMap objectForKey:serviceName];
        if(proxy != nil){
            _lastAccessTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
            prxBlock(proxy);
            return;
        }
        proxy = [self createIceProxy:_communicator serviceName:serviceName class:serviceCls];
        [_cls2PrxMap setObject:proxy forKey:serviceName];
        _lastAccessTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
        
        prxBlock(proxy);
    });
}

/**
 *  创建ICE连接器
 *
 *  @param c           ICECommunicator
 *  @param serviceName serviceName
 *  @param serviceCls  服务代理类
 *
 *  @return ICEObjectPrx
 */
- (id<ICEObjectPrx>) createIceProxy:(id<ICECommunicator>)c serviceName:(NSString*)serviceName class:(Class)serviceCls {
    id<ICEObjectPrx> proxy = nil;
    @try{
        ICEObjectPrx* base = [_communicator stringToProxy:serviceName];
        base = [base ice_invocationTimeout:_idleTimeOutSeconds];
        proxy = [serviceCls checkedCast:base];
        return proxy;
    } @catch(ICEEndpointParseException* ex) {
        return (ICEObjectPrx*)ex;
    } @catch(ICEException* ex) {
        return (ICEObjectPrx*)ex;
    }@catch(NSException* ex){
        return (ICEObjectPrx*)ex;
    }
}

- (void)createMonitoerThread{
    _stoped = NO;
    _monitorThread = [[NSThread alloc]initWithTarget:self selector:@selector(monitor) object:nil];
    [_monitorThread start];
}

- (void) monitor{
    while(!_stoped){
        @try{
            // 让当前线程睡眠 5.0 秒
            [NSThread sleepForTimeInterval:5.0f];
            NSInteger nowTime = [[NSDate date] timeIntervalSince1970]*1000;
            if(_lastAccessTimestamp + _idleTimeOutSeconds * 1000L < nowTime){
                [self closeCommunicator:true];
            }
        }@catch(NSException * e){
            NSLog(@"%@",[e description]);
        }
    }
}

@end