//
//  LSLTimer.m
//  LSLTimer
//
//  Created by Jason on 2019/3/23.
//  Copyright © 2019 友邦创新资讯. All rights reserved.
//

#import "LSLTimer.h"

@interface LSLTimer ()

@property (nonatomic,strong)dispatch_source_t timer;


@end

@implementation LSLTimer

//存储创建出的timer timerID做为key timer做为value
static NSMutableDictionary *timers;

//创建锁
dispatch_semaphore_t semaphore;
/**
 * 初始化字典
 */
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
}

+ (NSString *)executeTask:(void(^)(void))task
              start:(NSTimeInterval)start
           interval:(NSTimeInterval)interval
            repeats:(BOOL)repeats
              async:(BOOL)async {
    //判空操作
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
    
       //创建队列
       dispatch_queue_t queue = async? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
       //创建定时器
       dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
       //设置时间
       dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(start * NSEC_PER_SEC) ), (uint64_t)(interval * NSEC_PER_SEC), 0);
    
      //防止多线程访问字典
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      //定时器的唯一标识
       NSString *timerID = [NSString stringWithFormat:@"%ld",timers.count];
     //存储定时器
      timers[timerID] = timer;
    
    //发送信号
     dispatch_semaphore_signal(semaphore);
    
      //设置回掉
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTimerWithName:timerID];
        }
    });
    //启动timer
    dispatch_resume(timer);
    
    return timerID;
}


+ (NSString *)executeTarget:(id)target
                   selector:(SEL)selector
                      start:(NSTimeInterval)start
                   interval:(NSTimeInterval)interval
                    repeats:(BOOL)repeats
                      async:(BOOL)async {
    if (target || selector) return nil;
    
    return [self executeTask:^{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector];

    #pragma clang diagnostic pop

        
    } start:start interval:interval repeats:repeats async:async];
}

/**
 * 根据定时器的标识删除定时器
 */
+ (void)cancelTimerWithName:(NSString *)timerID; {
    if (timerID.length == 0) return;
   
    //防止多线程读取字典
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timers[timerID];
    if(timer){
        dispatch_source_cancel(timers[timerID]);
        [timers removeObjectForKey:timerID];
    }
    //发送信号
    dispatch_semaphore_signal(semaphore);
}

@end
