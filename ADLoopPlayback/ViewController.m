//
//  ViewController.m
//  ADLoopPlayback
//
//  Created by GE on 16/2/15.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ViewController.h"
#import "HY_ADLoopView.h"


@interface ViewController () <HY_ADLoopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
   
}
- (void)createUI {
    
    NSArray * imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"测试图1"],[UIImage imageNamed:@"测试图2"],[UIImage imageNamed:@"测试图3"],[UIImage imageNamed:@"测试图4"], nil];
    
    HY_ADLoopView * loopView = [[HY_ADLoopView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)andImages:imageArr];
    
    loopView.delegate = self;
    
    
    [self.view addSubview:loopView];
}


#pragma mark HY_ADLoopViewDelegate

- (void)loopView:(HY_ADLoopView *)loopView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index = %d",index);
}

@end
