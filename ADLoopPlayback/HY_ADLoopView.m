//
//  HY_ADLoopView.m
//  ADLoopPlayback
//
//  Created by GE on 16/2/15.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "HY_ADLoopView.h"

@interface HY_ADLoopView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray * ImageArr;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger currentWidth;
@property (nonatomic, assign) NSInteger currentHeight;
@property (nonatomic, assign) NSInteger curImgIndex;

@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * rightImageView;
@property (nonatomic, strong) UIImageView * centerImageView;

@property (nonatomic, strong) NSTimer * timer;


@end

@implementation HY_ADLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _currentWidth = frame.size.width;
        _currentHeight = frame.size.height;
        [self createUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _currentWidth = frame.size.width;
        _currentHeight = frame.size.height;
        self.ImageArr = images;
        
        [self createUI];
        
    }
    return self;
}


- (void)createUI {
    
    //scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * 3, _scrollView.bounds.size.height);
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:NO];

    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    
    //初始化三个imageview
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _currentWidth,_scrollView.bounds.size.height)];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_currentWidth, 0, _currentWidth,_scrollView.bounds.size.height)];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_currentWidth * 2, 0, _currentWidth ,_scrollView.bounds.size.height)];
    NSArray * ivArr = [NSArray arrayWithObjects:_leftImageView,_centerImageView,_rightImageView, nil];
    for (UIImageView * imageView in ivArr) {
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
        
        [imageView addGestureRecognizer:tap];
    }
    
    
    
    
    
    
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_rightImageView];
    [_scrollView addSubview:_centerImageView];
    
    
    _scrollView.contentOffset = CGPointMake(_currentWidth, 0);
    
    _centerImageView.image = self.ImageArr.firstObject;
    _leftImageView.image = self.ImageArr.lastObject;
    _rightImageView.image = self.ImageArr[1];

    
    
    

    _scrollView.backgroundColor = [UIColor redColor];
    [self addSubview:_scrollView];
    
    //pagecontrol
    _pageControl = [[UIPageControl alloc]init];
    CGSize controlSize = [_pageControl sizeForNumberOfPages:self.ImageArr.count];
    _pageControl.bounds = CGRectMake(0, 0, controlSize.width, controlSize.height);
    _pageControl.center = CGPointMake(_currentWidth * 0.5, _currentHeight - 20);
    //设置圆点颜色
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    //设置总页数
    _pageControl.numberOfPages = self.ImageArr.count;
    [self addSubview:_pageControl];
    
    _curImgIndex = 0;
    _pageControl.currentPage = _curImgIndex;
    //计时器
    
    [self setupTimer];
    
    
}

- (void)tapImage {
    if (_delegate && [_delegate respondsToSelector:@selector(loopView:didSelectItemAtIndex:)]) {
        [_delegate loopView:self didSelectItemAtIndex:self.pageControl.currentPage];
    }
}

#pragma mark - 



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self reloadImage];
    [_scrollView setContentOffset:CGPointMake(_currentWidth, 0) animated:NO];
    _pageControl.currentPage = _curImgIndex;
    

}



- (void)reloadImage {
    NSInteger leftImageIndex, rightImageIndex;
    
    CGPoint offset = [_scrollView contentOffset];
    
    
    if (offset.x > _currentWidth) {//向右滚动
        _curImgIndex = (_curImgIndex + 1) % self.ImageArr.count;
    }else if (offset.x < _currentWidth) {//向左滚动
        _curImgIndex = (_curImgIndex + self.ImageArr.count - 1) % self.ImageArr.count;
    }

    _centerImageView.image = self.ImageArr[_curImgIndex];
    
    leftImageIndex = (_curImgIndex - 1) % self.ImageArr.count;
    rightImageIndex = (_curImgIndex + 1) % self.ImageArr.count;
    
    

    _leftImageView.image = self.ImageArr[leftImageIndex];
    _rightImageView.image = self.ImageArr[rightImageIndex];;
    
}

- (void)setupTimer {
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(pageChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

///pagechanged
- (void)pageChanged {
    CGPoint offset = _scrollView.contentOffset;
    offset.x += offset.x;
    [_scrollView setContentOffset:offset animated:YES];
   
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"test");
    [self reloadImage];
    [_scrollView setContentOffset:CGPointMake(_currentWidth, 0) animated:NO];
    _pageControl.currentPage = _curImgIndex;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
