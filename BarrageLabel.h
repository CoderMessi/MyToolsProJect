//
//  BarrageLabel.h
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/6.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageLabel : UILabel

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, assign) CGFloat currentTime;

@end
