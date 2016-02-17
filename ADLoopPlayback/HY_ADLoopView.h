//
//  HY_ADLoopView.h
//  ADLoopPlayback
//
//  Created by GE on 16/2/15.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HY_ADLoopView;

@protocol HY_ADLoopViewDelegate <NSObject>

- (void)loopView:(HY_ADLoopView *)loopView didSelectItemAtIndex:(NSInteger)index;

@end


@interface HY_ADLoopView : UIView

@property (nonatomic, weak) id<HY_ADLoopViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images;

@end
