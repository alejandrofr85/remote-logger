//
//  AMRemoteFileLogger.m
//  RemoteLogger
//
//  Original Work Copyright (c) 2010-2016, Deusty, LLC
//  All rights reserved.
//
//  Created by Alejandro M Moreno on 3/23/17.
//  Modified Work Copyright © 2017 Alejandro M Moreno. All rights reserved.
//

#import "AMRemoteFileLogger.h"

#ifndef DD_NSLOG_LEVEL
#define DD_NSLOG_LEVEL 2
#endif

#define NSLogError(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 1) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogWarn(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 2) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogInfo(frmt, ...)     do{ if(DD_NSLOG_LEVEL >= 3) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogDebug(frmt, ...)    do{ if(DD_NSLOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#define NSLogVerbose(frmt, ...)  do{ if(DD_NSLOG_LEVEL >= 5) NSLog((frmt), ##__VA_ARGS__); } while(0)

static NSString *const kAMRemoteFileLoggerLastUploadDate = @"kAMRemoteFileLoggerLastUploadDate";

NSTimeInterval const kAMDefaultLogUploadingFrequency = 60 * 60 * 1;     // 1 Hour

@interface AMRemoteFileLogger(){
    NSTimeInterval _uploadingFrequency;
}
@property (nonatomic) NSDate *lastUploadDate;

@end

@interface AMRemoteFileLogger(Private)
- (void)rollLogFileNow;
@end


@implementation AMRemoteFileLogger

-(instancetype)initWithLogFileManager:(id<DDLogFileManager>)logFileManager{
    if (self = [super initWithLogFileManager:logFileManager]) {
        _uploadingFrequency = kAMDefaultLogUploadingFrequency;
    }
    return self;
}

- (NSTimeInterval)uploadingFrequency {
    __block NSTimeInterval result;
    
    dispatch_block_t block = ^{
        result = _uploadingFrequency;
    };
    
    // The design of this method is taken from the DDAbstractLogger implementation.
    // For extensive documentation please refer to the DDAbstractLogger implementation.
    
    // Note: The internal implementation should access the rollingFrequency variable directly,
    // This method is designed explicitly for external access.
    //
    // Using "self." syntax to go through this method will cause immediate deadlock.
    // This is the intended result. Fix it by accessing the ivar directly.
    // Great strides have been take to ensure this is safe to do. Plus it's MUCH faster.
    
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(self.loggerQueue, block);
    });
    
    return result;
}

- (void)setUploadingFrequency:(NSTimeInterval)newUploadingFrequency {
    dispatch_block_t block = ^{
        @autoreleasepool {
            _uploadingFrequency = newUploadingFrequency;
            [self maybeUpload];
        }
    };
    
    // The design of this method is taken from the DDAbstractLogger implementation.
    // For extensive documentation please refer to the DDAbstractLogger implementation.
    
    // Note: The internal implementation should access the uploadingFrequency variable directly,
    // This method is designed explicitly for external access.
    //
    // Using "self." syntax to go through this method will cause immediate deadlock.
    // This is the intended result. Fix it by accessing the ivar directly.
    // Great strides have been taken to ensure this is safe to do. Plus it's MUCH faster.
    
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    
    dispatch_queue_t globalLoggingQueue = [DDLog loggingQueue];
    
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(self.loggerQueue, block);
    });
}

- (void)maybeUpload {
    if (_uploadingFrequency > 0.0 && [self intervalSinceLastUpload] >= _uploadingFrequency) {
        NSLogVerbose(@"DDFileLogger: Rolling log file due to age...");
        [self rollLogFileNow];
        [self uploadFiles];
    }
}

- (void)uploadFiles {
    
}

- (NSTimeInterval)intervalSinceLastUpload{
    if (!self.lastUploadDate) {
        id object = [[NSUserDefaults standardUserDefaults] objectForKey:kAMRemoteFileLoggerLastUploadDate];
        if ([object isKindOfClass:[NSDate class]]) {
            self.lastUploadDate = (NSDate *)object;
        }
    }
    return [[NSDate date] timeIntervalSinceDate:self.lastUploadDate];
}

- (void)setUpdateLastUpdateDate{
    self.lastUploadDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:self.lastUploadDate forKey:kAMRemoteFileLoggerLastUploadDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
