//
//  AMFileLogger.h
//  RemoteLogger
//
//  Created by Alejandro M Moreno on 3/23/17.
//  Copyright © 2017 Alejandro M Moreno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMFileLoggerLogLevel) {
    AMFileLoggerLogLevelDebug,
    AMFileLoggerLogLevelInfo,
    AMFileLoggerLogLevelWarning,
    AMFileLoggerLogLevelError
};

@interface AMFileLogger : NSObject

@property AMFileLoggerLogLevel loggerLevel;

+ (instancetype)sharedLogger;

+ (void)logWithLevel:(AMFileLoggerLogLevel)level
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);

@end
