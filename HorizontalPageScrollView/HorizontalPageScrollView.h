//
//  HorizontalPageScrollView.h
//  HorizontalPageScrollView
//
//  Created by kitano on 2013/11/16.
//  Copyright (c) 2013年 kitano. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HorizontalPageScrollViewDateSource;
@protocol HorizontalPageScrollViewDelegate;

@interface HorizontalPageScrollView : UIView
<UIScrollViewDelegate>

@property (nonatomic,retain) id<HorizontalPageScrollViewDateSource> datasource;
@property (nonatomic,retain) id<HorizontalPageScrollViewDelegate>   delegate;
-(void)changeAllFrame:(CGRect)frame;
@end

@protocol HorizontalPageScrollViewDateSource <NSObject>
-(int)numberInView:(HorizontalPageScrollView*)scrollView;
-(int)startIndex:(HorizontalPageScrollView*)scrollView;
-(UIView*)viewAtIndex:(int)index scrollView:(HorizontalPageScrollView*)scrollView;
@end

@protocol HorizontalPageScrollViewDelegate <NSObject>
-(void)changeCurrentIndex:(int)index;
@end
