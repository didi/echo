//
//  ECOCrashFileInfo.h
//  EchoSDK
//
//  Created by Lux on 2019/11/4.
//

#import <Foundation/Foundation.h>

/*!
 崩溃类型
 参考：
 https://juejin.im/post/5d76184ce51d4561d106cc65
 */
typedef NS_ENUM(NSInteger, ECOCrashType) {
    /*!
     系统异常
     */
    ECOCrashTypeUncaught,
    
    /*!
     内核异常
     */
    ECOCrashTypeSignal,
};

NS_ASSUME_NONNULL_BEGIN

@interface ECOCrashFileInfo : NSObject

/*!
 文件名，文件名由 creatDate 和 crashType 决定
 */
@property (nonatomic, copy, readonly) NSString *fileName;

/*!
 文件存储路径
 */
@property (nonatomic, copy, readonly) NSString *filePath;

/*!
 文件目录
 */
@property (nonatomic, copy) NSString *fileDirctory;

/*!
 崩溃详情
 */
@property (nonatomic, copy) NSString *crashInfo;

/*!
 文件的创建日期，会在调用 newWithContent 时创建
 */
@property (nonatomic, copy, readonly) NSDate *crashDate;
@property (nonatomic, copy, readonly) NSString *crashDateString;

/*!
 崩溃类型
 */
@property (nonatomic, assign) ECOCrashType crashType;
@property (nonatomic, copy) NSString *crashTypeString;

/*!
 通过文件类型和崩溃信息创建一个崩溃日志对象（本地还未写入）
 */
- (instancetype)initWithCrashInfo:(NSString *)crashInfo type:(ECOCrashType)type;

/*!
 通过读取文件路径创建一个崩溃日志文件对象；
 */
- (instancetype)initWithFilePath:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
