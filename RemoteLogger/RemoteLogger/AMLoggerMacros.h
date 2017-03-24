//
//  AMLoggerMacros.h
//  RemoteLogger
//
//  Created by Alejandro M Moreno on 3/23/17.
//  Copyright © 2017 Alejandro M Moreno. All rights reserved.
//

#import <RemoteLogger/AMFileLogger.h>

#define LOG_MACRO(lvl,frmt, ...) [AMFileLogger logWithLevel:lvl file : __FILE__ function : __PRETTY_FUNCTION__ line : __LINE__ format : (frmt), ## __VA_ARGS__]

#define AMLogError(frmt, ...)   LOG_MACRO(AMFileLoggerLogLevelError,        frmt, ##__VA_ARGS__)
#define AMLogWarn(frmt, ...)    LOG_MACRO(AMFileLoggerLogLevelWarning,      frmt, ##__VA_ARGS__)
#define AMLogInfo(frmt, ...)    LOG_MACRO(AMFileLoggerLogLevelInfo,         frmt, ##__VA_ARGS__)
#define AMLogDebug(frmt, ...)   LOG_MACRO(AMFileLoggerLogLevelDebugDebug,   frmt, ##__VA_ARGS__)
