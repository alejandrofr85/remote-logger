//
//  AMFileLogger.m
//  RemoteLogger
//
//  Created by Alejandro M Moreno on 3/23/17.
//  Copyright © 2017 Alejandro M Moreno. All rights reserved.
//

#import "AMFileLogger.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AMFileLogger ()

@property (nonatomic) DDLog *internalLogger;

@end

@implementation AMFileLogger

- (instancetype)init {
    if (self = [super init]) {
        _internalLogger = [DDLog new];
        _loggerLevel = AMFileLoggerLogLevelDebug;
        
        [_internalLogger addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
        [_internalLogger addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
        
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 * 5; // 5 day rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
        fileLogger.maximumFileSize = 2 * 1024 * 1024;
        
        [_internalLogger addLogger:fileLogger];
        
    }
    return self;
}

+ (instancetype)sharedLogger {
    static AMFileLogger *sharedInstance;
    static dispatch_once_t FileLoggerOnceToken;
    dispatch_once(&FileLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


+ (void)logWithLevel:(AMFileLoggerLogLevel)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... {
    if (level < [[self sharedLogger] loggerLevel]) {
        return;
    }
    
    
//
//    DDLogMessage
//    
//    [self sharedLogger] logMessage:<#(DDLogMessage *)#>
    
}

@end
