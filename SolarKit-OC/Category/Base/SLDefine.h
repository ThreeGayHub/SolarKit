//
//  SLDefine.h
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#ifndef SLDefine_h
#define SLDefine_h

//NSLog
#if (DEBUG)
#define NSLog(format, ...) printf("\n[%s]\n-------------------- NTLOG -------------------- \n%s\n-----------------------------------------------\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* SLDefine_h */
