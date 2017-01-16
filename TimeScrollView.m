//
//  TimeScrollView.m
//  InfiniteScrollView
//
//  Created by xalo on 2017/1/16.
//  Copyright © 2017年 llf. All rights reserved.
//

#import "TimeScrollView.h"
#import "UIImageView+WebCache.h"
//判断外部传递进来的图片类型
typedef enum : NSUInteger {
    ImageName = 100,
    ImageUrl,
    Image,
} SourceType;


@interface TimeScrollView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *myScrollView;
@property(nonatomic,strong)UIImageView *leftImageView;
@property(nonatomic,strong)UIImageView *centerImageView;
@property(nonatomic,strong)UIImageView *rightIamgeView;
@property(nonatomic,assign)int currentIndex;//记录当前显示的图片在数组中的位置
@property(nonatomic,strong)UIPageControl *myPageControl;
@property(nonatomic,strong)NSTimer *times;

@property(nonatomic,assign)SourceType imageType;
@end

@implementation TimeScrollView
- (NSTimer*)times{
    if (_times == nil) {
        _times = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [_times setFireDate:[NSDate distantFuture]];
        
    }
    return _times;
}

- (UIPageControl*)myPageControl{
    if (_myPageControl == nil) {
        _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-200)/2, CGRectGetHeight(self.bounds)-40, 200, 40)];
        //视图的透明度不会影响上面子视图的透明度
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [bgView addSubview:_myPageControl];
        [self addSubview:bgView];
    }
    return _myPageControl;
}

- (UIScrollView*)myScrollView{
    if (_myScrollView == nil) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _myScrollView.pagingEnabled = YES;
        _myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, CGRectGetHeight(self.bounds));
        //将显示的子视图永远是第一屏（0，1，2）
        
        _myScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        _myScrollView.delegate = self;
        
        //
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.myScrollView addGestureRecognizer:tap];
        
        [self addSubview:_myScrollView];
    }
    return _myScrollView;
}


- (UIImageView*)leftImageView{
    if (_leftImageView == nil) {
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.myScrollView addSubview:_leftImageView];
    }
    return _leftImageView;
}
- (UIImageView*)centerImageView{
    if (_centerImageView == nil) {
        
         _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        
        
         _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.myScrollView addSubview:_centerImageView];
    }
    return _centerImageView;
}
- (UIImageView*)rightIamgeView{
    if (_rightIamgeView == nil) {
        
         _rightIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)*2, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
         _rightIamgeView.contentMode = UIViewContentModeScaleAspectFit;
        [self.myScrollView addSubview:_rightIamgeView];
    }
    return _rightIamgeView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //为三张图片赋初始图片
//        self.leftImageView.image = [UIImage imageNamed:@"f456.jpg"];
//        self.centerImageView.image = [UIImage imageNamed:@"f456.jpg"];
//        self.rightIamgeView.image = [UIImage imageNamed:@"f456.jpg"];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
//重写数组的setter方法，当执行该方法的时候，说明外部给数据了

- (void)setImagesMArray:(NSMutableArray *)imagesMArray{
    
    if (imagesMArray == nil || imagesMArray.count == 0) {
        
        NSLog(@"数据源不能为空");
        return;
    }
    
    
    //判断数据源的类型
    id source = imagesMArray.firstObject;
    if ([source isKindOfClass:[UIImage class]]) {
        //说明数组元素为图片类型，调用对应的初始化方法
        self.imageType = Image;
        [self sourceIsUIImageWithArray:imagesMArray];
    }else {
        //说明为字符串
        NSString *sourceString = imagesMArray.firstObject;
        if ([sourceString hasPrefix:@"http"]) {
            //说明是图片链接
            self.imageType = ImageUrl;
            [self sourceIsImageUrlWithArray:imagesMArray];
        }else{
            self.imageType = ImageName;
            [self sourceIsImageNamedWithArray:imagesMArray];
        }
    }
    
    
    
    _imagesMArray = imagesMArray;
    //当我们确定了数据的个数的时候，我们才可以确定小白点的个数
    self.myPageControl.numberOfPages = _imagesMArray.count;
    self.myPageControl.currentPage = 0;
    [self.times setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}


//当数据源为图片名称的时候
- (void)sourceIsImageUrlWithArray:(NSArray*)sourceArray{
    if (sourceArray.count == 1) {
        
        //只有一张图片的时候，不能让ScrollView滚动
        NSString *urlString = sourceArray.firstObject;
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];
        
        self.myScrollView.scrollEnabled = NO;
    }else if(sourceArray.count >= 2){
        //取出最后一张元素，赋值给最左边的
        NSString* lastString = sourceArray.lastObject;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:lastString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];

        
        NSString* firstString = sourceArray.firstObject;
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:firstString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];

        //初始化位置索引
        self.currentIndex = 0;
        
        NSString* nextString = sourceArray[1];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:nextString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];
        
    }
    
}

//当数据源为UiIamge类型的时候
- (void)sourceIsUIImageWithArray:(NSArray*)sourceArray{
    if (sourceArray.count == 1) {
        
        //只有一张图片的时候，不能让ScrollView滚动
        
        self.centerImageView.image =sourceArray.firstObject;
        
        self.myScrollView.scrollEnabled = NO;
    }else if(sourceArray.count >= 2){
        //取出最后一张元素，赋值给最左边的
        
        self.leftImageView.image = sourceArray.lastObject;
        
     
        self.centerImageView.image = sourceArray.firstObject;
        //初始化位置索引
        self.currentIndex = 0;
        self.rightIamgeView.image = sourceArray[1];
    }
    
}


//当数据源为图片名称的时候
- (void)sourceIsImageNamedWithArray:(NSArray*)sourceArray{
    if (sourceArray.count == 1) {
        
        //只有一张图片的时候，不能让ScrollView滚动
        
        self.centerImageView.image = [UIImage imageNamed:sourceArray.firstObject];
        
        self.myScrollView.scrollEnabled = NO;
    }else if(sourceArray.count >= 2){
        //取出最后一张元素，赋值给最左边的
        NSString* lastString = sourceArray.lastObject;
        self.leftImageView.image = [UIImage imageNamed:lastString];
        
        NSString* firstString = sourceArray.firstObject;
        self.centerImageView.image = [UIImage imageNamed:firstString];
        //初始化位置索引
        self.currentIndex = 0;
        
        NSString* nextString = sourceArray[1];
        self.rightIamgeView.image = [UIImage imageNamed:nextString];
    }

}



//当用手拖拽时，停止定时器，
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //
    [self.times setFireDate:[NSDate distantFuture]];
}

//


//停止减速时，画面静止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //先判断滑动方向
    if (scrollView.contentOffset.x >= CGRectGetWidth(self.bounds)*2) {
        //向右滑动了，应该在基础上加1
        self.currentIndex++;
    }
    if(scrollView.contentOffset.x <= 0){
        //向左滑动，应该在基础上减一
        self.currentIndex--;
    }
    
    
    if (self.currentIndex >= (int)self.imagesMArray.count ) {
        //说明越界了，要重置
        self.currentIndex = 0;
    }
    
    if (self.currentIndex <= -1) {
        //说明当前显示的为第0张，在减一，就用该显示左后一张
        self.currentIndex = (int)self.imagesMArray.count -1;
    }
    //改变小白点的
    self.myPageControl.currentPage = self.currentIndex;
    
    //先将显示的图片进行更改
    //将scrollView的偏移量进行更改
    [self changeImageWithCurrentIndex:self.currentIndex];
    //当画面静止  1~2秒
    [self.times setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}

//当滚动视图的shihou，切换视图调用的方法,整个无限轮播图的核心算法
- (void)changeImageWithCurrentIndex:(int)index{
    
    switch (self.imageType) {
        case ImageName:
            [self changeImageNameWithIndex:index];
            break;
            
        case ImageUrl:
            [self changeImageUrlWithIndex:index];
            break;
            
        case Image:
            [self changeUIImageWithIndex:index];
            break;
        default:
            break;
    }
    //将偏移量改回中间位置
//    
    [self.myScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0) animated:NO] ;
}
//图片名
- (void)changeImageNameWithIndex:(int)index{
    NSString *centerString = [self.imagesMArray objectAtIndex:index];
    self.centerImageView.image = [UIImage imageNamed:centerString];
    //确定左右两边需要显示的图片
    NSString *leftString;
    NSString *rightString;
    if (index == 0) {
        leftString = self.imagesMArray.lastObject;
        rightString = self.imagesMArray[index+1];
    }else if(index == self.imagesMArray.count -1){
        leftString = self.imagesMArray[index-1];
        rightString = self.imagesMArray.firstObject;
    }else{
        leftString = self.imagesMArray[index - 1];
        rightString = self.imagesMArray[index + 1];
    }
    
    self.leftImageView.image = [UIImage imageNamed:leftString];
    self.rightIamgeView.image = [UIImage imageNamed:rightString];
}
//图片链接
- (void)changeImageUrlWithIndex:(int)index{
    NSString *centerString = [self.imagesMArray objectAtIndex:index];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:centerString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];
    //确定左右两边需要显示的图片
    NSString *leftString;
    NSString *rightString;
    if (index == 0) {
        leftString = self.imagesMArray.lastObject;
        rightString = self.imagesMArray[index+1];
    }else if(index == self.imagesMArray.count -1){
        leftString = self.imagesMArray[index-1];
        rightString = self.imagesMArray.firstObject;
    }else{
        leftString = self.imagesMArray[index - 1];
        rightString = self.imagesMArray[index + 1];
    }
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:leftString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];
    [self.rightIamgeView sd_setImageWithURL:[NSURL URLWithString:rightString] placeholderImage:[UIImage imageNamed:@"f456.jpg"]];
}
//图片
- (void)changeUIImageWithIndex:(int)index{
    
//    NSString *centerString = [self.imagesMArray objectAtIndex:index];
    self.centerImageView.image = [self.imagesMArray objectAtIndex:index];
    //确定左右两边需要显示的图片
    UIImage *leftImage;
    UIImage *rightImage;
    if (index == 0) {
        leftImage = self.imagesMArray.lastObject;
        rightImage = self.imagesMArray[index+1];
    }else if(index == self.imagesMArray.count -1){
        leftImage = self.imagesMArray[index-1];
        rightImage = self.imagesMArray.firstObject;
    }else{
        leftImage = self.imagesMArray[index - 1];
        rightImage = self.imagesMArray[index + 1];
    }
    
    self.leftImageView.image = leftImage;
    self.rightIamgeView.image = rightImage;
}

//手势
- (void)tapAction{
    if (self.passBlock) {
        self.passBlock(self.currentIndex);
    }
}

//定时器
- (void)timeAction{
    
    //改变偏移量
    [self.myScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*2, 0) animated:YES];
    //向右
    self.currentIndex++;
    
    if (self.currentIndex >= (int)self.imagesMArray.count ) {
        //说明越界了，要重置
        self.currentIndex = 0;
    }
    //改变小白点的
    self.myPageControl.currentPage = self.currentIndex;
    
    //为了看到动画效果，延迟调用change方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeImageWithCurrentIndex:self.currentIndex];
    });
    
    
}

@end
