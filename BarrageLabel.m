//
//  BarrageLabel.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/6.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "BarrageLabel.h"

@implementation BarrageLabel

- (BarrageLabel *)init
{
    if (self = [super init]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)updateTime
{
    self.currentTime -= 0.3f;
    if (self.currentTime > 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    }
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
