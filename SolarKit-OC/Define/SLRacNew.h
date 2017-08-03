//
//  SLRacNew.h
//  Example
//
//  Created by wyh on 2017/8/3.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#ifndef SLRacNew_h
#define SLRacNew_h

//第一次不执行的RACObserve
#define RACObserveNew(TARGET, KEYPATH) \
({ \
__weak id target_ = (TARGET); \
[[target_ rac_valuesAndChangesForKeyPath:@keypath(TARGET, KEYPATH) options:NSKeyValueObservingOptionNew observer:self] map:^(RACTuple *value) {\
return value[0];\
}]; \
})\

#endif /* SLRacNew_h */
