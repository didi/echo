//
//  ECONetServiceBrowser.m
//  Echo
//
//  Created by 陈爱彬 on 2019/4/17. Maintain by 陈爱彬
//  Description 
//

#import "ECONetServiceBrowser.h"

static uint16_t const  ECONetServicePortNumber  = 23234;
static NSString *const ECONetServiceDomain      = @"";
static NSString *const ECONetServiceType        = @"_ECHO._tcp";
static NSString *const ECONetServiceName        = @"";
static NSTimeInterval const ECONetServiceResolveAddressTimeout = 30;

@interface ECONetServiceBrowser()
<NSNetServiceDelegate,
NSNetServiceBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;

@end

@implementation ECONetServiceBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Browser Services
//启动Bonjour服务搜索
- (void)startBrowsing {
    [self.services removeAllObjects];
    //创建Browser对象
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.includesPeerToPeer = YES;
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:ECONetServiceType inDomain:ECONetServiceDomain];
}
//重置查找服务
- (void)resetBrowserService {
    [self.serviceBrowser stop];
    self.serviceBrowser = nil;
    //重启查找
    [self startBrowsing];
}
#pragma mark - NSNetServiceBrowserDelegate methods

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"%s",__func__);
    //解析服务
    [self.services addObject:service];
    service.delegate = self;
    [service resolveWithTimeout:ECONetServiceResolveAddressTimeout];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"%s",__func__);
    //移除服务
    [self.services removeObject:service];
    service.delegate = nil;
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    NSLog(@"%s",__func__);
    //重试
    [self resetBrowserService];
}
#pragma mark - NSNetServiceDelegate methods

/* Sent to the NSNetService instance's delegate when one or more addresses have been resolved for an NSNetService instance. Some NSNetService methods will return different results before and after a successful resolution. An NSNetService instance may get resolved more than once; truly robust clients may wish to resolve again after an error, or to resolve more than once.
 */
- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"%s",__func__);
    //解析address地址
    NSString *name = [sender name];
    NSString *hostName = name ?: [sender hostName];
    NSArray *addresses = [[sender addresses] copy];
    !self.addressesBlock ?: self.addressesBlock(addresses, hostName ?: @"");
}

/* Sent to the NSNetService instance's delegate when the instance's previously running publication or resolution request has stopped.
 */
- (void)netServiceDidStop:(NSNetService *)sender {
    NSLog(@"%s",__func__);
}

#pragma mark - getters
- (NSMutableArray *)services {
    if (!_services) {
        _services = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _services;
}

@end
