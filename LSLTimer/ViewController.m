//
//  ViewController.m
//  LSLTimer
//
//  Created by Jason on 2019/3/23.
//  Copyright © 2019 友邦创新资讯. All rights reserved.
//

#import "ViewController.h"
#import "LSLTimer.h"

@interface ViewController ()

@property (nonatomic,copy)NSString *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.task = [LSLTimer executeTask:^{
       NSLog(@"开启timer");
    } start:2 interval:1 repeats:YES async:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [LSLTimer cancelTimerWithName:self.task];
}
@end
