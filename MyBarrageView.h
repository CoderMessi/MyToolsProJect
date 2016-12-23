//
//  MyBarrageView.h
//  MyToolsProject
//
//  Created by 宋瑞航 on 16/7/6.
//  Copyright © 2016年 SRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBarrageView : UIView

//重新设置数据源
- (void)setData:(NSArray *)dataObject;
//向后追加数据源
- (void)appendData:(NSArray *)dataObj;
//向前添加数据源
- (void)forwardData:(NSArray *)dataObj;
//开始弹幕
- (void)start;
//结束弹幕
- (void)stop;

@end
