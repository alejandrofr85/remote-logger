//
//  AMRemoteFileLogger.h
//  RemoteLogger
//
//  Created by Alejandro M Moreno on 3/24/17.
//  Copyright © 2017 Alejandro M Moreno. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AMRemoteFileLogger : DDFileLogger

@property (readwrite, assign) NSTimeInterval uploadingFrequency;

@end
