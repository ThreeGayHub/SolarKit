//
//  SLLog.h
//  Example
//
//  Created by wyh on 2017/8/3.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#ifndef SLLog_h
#define SLLog_h

//NSLog
#if (DEBUG)
#define NSLog(format, ...) printf("\n[%s]\n-------------------- NSLOG -------------------- \n%s\n-----------------------------------------------\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* SLLog_h */
