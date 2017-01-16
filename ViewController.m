//
//  ViewController.m
//  InfiniteScrollView
//
//  Created by xalo on 2017/1/16.
//  Copyright © 2017年 llf. All rights reserved.
//

#import "ViewController.h"
#import "TimeScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TimeScrollView *scrollView = [[TimeScrollView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 300)];
    
    NSString *urlString1 = @"http://pic2.ooopic.com/11/81/01/16b2OOOPIC8c.jpg";
     NSString *urlString2 = @"http://cdn4.haibao.cn/store/wm/bigfiles/200924/887EDBB8ECC69AB68AF2D5C74FAB89.jpg";
     NSString *urlString3 = @"http://image.tianjimedia.com/uploadImages/2014/113/40/PMCZD10TC4UM_680x500.jpg";
     NSString *urlString4 = @"http://www.sgxw.cn/uploadfile/2011/1022/20111022094539323.png";
     NSString *urlString5 = @"http://image.tianjimedia.com/uploadImages/2015/083/30/VVJ04M7P71W2.jpg";
    
    NSArray *urlArray = @[urlString1,urlString2,urlString3,urlString4,urlString5];
    
//    NSArray *array = @[@"fred",@"fblue",@"fblack",@"f456.jpg"];
    
    UIImage *image1 = [UIImage imageNamed:@"fred"];
     UIImage *image2 = [UIImage imageNamed:@"fblue"];
     UIImage *image3 = [UIImage imageNamed:@"fblack"];
     UIImage *image4 = [UIImage imageNamed:@"f456.jpg"];
//    NSArray *imageArray = @[image1,image2,image3,image4];
    scrollView.imagesMArray = [NSMutableArray arrayWithArray:urlArray];
    [self.view addSubview:scrollView];
    
    scrollView.passBlock = ^(int currentIndex){
        NSLog(@"%d",currentIndex);
    };
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
