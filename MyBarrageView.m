//
//  MyBarrageView.m
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/6.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import "MyBarrageView.h"
#import "BarrageLabel.h"

#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define VIEWHEIGHT_H (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define VIEWWIDTH_H (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))
#define CheckDeviceIsIpad 0

@interface MyBarrageView ()

@property (nonatomic, strong) NSTimer *timerBarrage;
@property (nonatomic, assign) BOOL bPortrait;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MyBarrageView {
    NSMutableArray *dataArr;
}

- (void)dealloc
{
    [self.timerBarrage setFireDate:[NSDate distantFuture]];
    [self.timerBarrage invalidate];
    self.timerBarrage = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        dataArr = [[NSMutableArray alloc] init];
        self.bPortrait = YES;
        self.timerBarrage = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(refreshBarrage) userInfo:nil repeats:YES];
        [self.timerBarrage setFireDate:[NSDate distantFuture]];
    }
    return self;
}

- (void)setData:(NSArray *)dataObject{
    dataArr = [NSMutableArray arrayWithArray:dataObject];
}

- (void)appendData:(NSArray *)dataObj{
    if (dataObj.count == 0) {
        return;
    }
    [dataArr addObjectsFromArray:dataObj];
}

- (void)forwardData:(NSArray *)dataObj
{
    if (dataObj.count == 0) {
        return;
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataObj.count)];
    [dataArr insertObjects:dataObj atIndexes:set];
}

- (void)start{
    self.index = 0;
    if (dataArr.count == 0) {
        [self stop];
        return;
    }
    if (!_timerBarrage) {
        _timerBarrage = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(refreshBarrage) userInfo:nil repeats:YES];
    }
    [_timerBarrage setFireDate:[NSDate distantPast]];
}

- (void)stop{
    
    [_timerBarrage setFireDate:[NSDate distantFuture]];
    [_timerBarrage invalidate];
    _timerBarrage = nil;
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[BarrageLabel class]])
        {
            [view removeFromSuperview];
        }
    }
}

- (void)refreshBarrage{
    if (_index > dataArr.count - 1) {
        //轮播
        self.index = 0;
        return;
    }
    
    [self showBarrage:dataArr[_index] owner:NO];
    self.index++;
}

- (void)showBarrage:(NSString *)comment owner:(BOOL)owner
{
    NSMutableArray *positions = nil;
    if (self.bPortrait)
    {
        positions = [NSMutableArray arrayWithObjects:@"25", @"50", @"75", @"100", nil];
    }
    else
    {
        if (IS_IPHONE4 || IS_IPAD)
        {
            int topBase = (int)((VIEWHEIGHT_H - VIEWWIDTH_H * 9 / 16) / 2);
            positions = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d", 85 + topBase], [NSString stringWithFormat:@"%d", 110 + topBase], [NSString stringWithFormat:@"%d", 135 + topBase], [NSString stringWithFormat:@"%d", 160 + topBase], nil];
        }
        else
        {
            positions = [NSMutableArray arrayWithObjects:@"85", @"110", @"135", @"160", nil];
        }
    }
    //for (int i = 0; i < 4; i++)
    {
        CGFloat randomY = [[positions objectAtIndex:(random() % 4)] floatValue];
        CGFloat animateSpeed1,animateSpeed2;
        
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[BarrageLabel class]])
            {
                BarrageLabel *label = (BarrageLabel *)view;
                if (label.frame.origin.y == (int)randomY && [label.layer.presentationLayer frame].origin.x + label.frame.size.width >= self.frame.size.width)//(label.frame.origin.y == (int)randomY && ((label.currentTime / label.totalTime * label.frame.size.width) >= self.view.frame.size.width))
                {
                    return;
                }
            }
        }
        CGSize commentSize = [comment sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
        BarrageLabel *label = [[BarrageLabel alloc] initWithFrame:CGRectMake(self.frame.size.width, randomY, commentSize.width, 20)];
        label.text = comment;
        label.font = [UIFont systemFontOfSize:18.0f];
        if(CheckDeviceIsIpad)
        {
            animateSpeed1 = 6;
            animateSpeed2 = 4;
            label.font = [UIFont systemFontOfSize:20.0f];
        }
        else
        {
            animateSpeed1 = 6 * ((commentSize.width / self.frame.size.width) + 1);
            animateSpeed2 = 4;
        }
        label.backgroundColor = [UIColor clearColor];
        if (owner)
        {
            label.textColor = [UIColor yellowColor];
        }
        else
        {
            label.textColor = [UIColor whiteColor];
        }
        [self addSubview:label];
        
        [UIView  animateWithDuration:animateSpeed1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.frame = CGRectMake(-label.frame.size.width, randomY, label.frame.size.width, label.frame.size.height);
            label.alpha = 0.5f;
        } completion:^(BOOL finished) {
            if (finished)
            {
                [label removeFromSuperview];
            }
        }];
    }
}



@end
