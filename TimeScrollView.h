//
//  TimeScrollView.h
//  InfiniteScrollView
//
//  Created by xalo on 2017/1/16.
//  Copyright © 2017年 llf. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PassBlock) (int currentIndex);


@interface TimeScrollView : UIView

@property(nonatomic,strong)NSMutableArray *imagesMArray;//

@property(nonatomic,strong)PassBlock passBlock;

@end
