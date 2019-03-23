//
//  LSLTimer.h
//  LSLTimer
//
//  Created by Jason on 2019/3/23.
//  Copyright © 2019 友邦创新资讯. All rights reserved.
//  

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLTimer : NSObject


+ (NSString *)executeTask:(void(^)(void))task
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async;


+ (NSString *)executeTarget:(id)target
                   selector:(SEL)selector
                      start:(NSTimeInterval)start
                   interval:(NSTimeInterval)interval
                    repeats:(BOOL)repeats
                      async:(BOOL)async;

+ (void)cancelTimerWithName:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END
