//
//  HorizontalPageScrollView.m
//  HorizontalPageScrollView
//
//  Created by kitano on 2013/11/16.
//  Copyright (c) 2013年 kitano. All rights reserved.
//

#import "HorizontalPageScrollView.h"


@implementation HorizontalPageScrollView
{
    NSInteger curIndex;
    NSInteger count;
    NSMutableArray *contentViews;
    BOOL setup_flg;
    UIScrollView *mainScrollView;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:mainScrollView];
        curIndex = 0;
        mainScrollView.delegate = self;
        mainScrollView.pagingEnabled = YES;
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator = NO;
        mainScrollView.scrollsToTop = NO;
        contentViews = [[NSMutableArray alloc] init];
        setup_flg = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if(setup_flg == NO) {
        setup_flg = YES;
        count = [_datasource numberInView:self];
        curIndex = [_datasource startIndex:self];
        mainScrollView.contentSize = CGSizeMake(self.frame.size.width * count,self.frame.size.height);
        mainScrollView.contentOffset = CGPointMake(self.frame.size.width* curIndex, 0);
        [self setUpView];
        [self setContentAtIndex:curIndex-1 contentView:contentViews[0]];
        [self setContentAtIndex:curIndex   contentView:contentViews[1]];
        [self setContentAtIndex:curIndex+1 contentView:contentViews[2]];
    }
}

-(void)setUpView
{
    CGRect frame = CGRectZero;
    frame.size = self.frame.size;
    frame.origin.x = (curIndex-1) * frame.size.width;
    
    for (int i=0; i < 3; i++) {
        UIScrollView *contentView = [self getContentScrollView:frame];
        [mainScrollView addSubview:contentView];
        [contentViews addObject:contentView];
        frame.origin.x += frame.size.width;
    }
    
}

- (void)setContentAtIndex:(NSInteger)index contentView:(UIScrollView*)scrollView
{
    if([scrollView.subviews  count] > 0) {
        UIView* contentView = [scrollView.subviews objectAtIndex:0];
        [contentView removeFromSuperview];
        contentView = nil;
    }
    if (index < 0 || count <= index) {
        scrollView.delegate = nil;
        return;
    }
    [scrollView addSubview: [_datasource viewAtIndex:index scrollView:self]];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isEqual:mainScrollView]) return;
    CGFloat pos   = scrollView.contentOffset.x / scrollView.bounds.size.width;
    CGFloat deff = pos - (CGFloat)curIndex;
    if (fabs(deff) >= 1.0f) {
        ((UIScrollView*)contentViews[1]).zoomScale = 1.0;
        ((UIScrollView*)contentViews[1]).contentOffset = CGPointZero;
        if (deff > 0) {
            [self goNextImage];
        } else {
            [self goPrevImage];
        }
    }
}
-(void)goPrevImage
{
    curIndex--;
    if ([_delegate respondsToSelector:@selector(changeCurrentIndex:)]) {
        [_delegate changeCurrentIndex:curIndex];
    }
    UIScrollView* tmpView = contentViews[1];
    contentViews[1] = contentViews[0];
    contentViews[0] = contentViews[2];
    contentViews[2] = tmpView;
    
    CGRect frame = ((UIScrollView*)contentViews[1]).frame;
    frame.origin.x -= frame.size.width;
    ((UIScrollView*)contentViews[0]).frame = frame;
    [self setContentAtIndex:curIndex-1 contentView:contentViews[0]];
}

-(void)goNextImage
{
    curIndex++;
    if ([_delegate respondsToSelector:@selector(changeCurrentIndex:)]) {
        [_delegate changeCurrentIndex:curIndex];
    }
    UIScrollView* tmpView = contentViews[1];
    contentViews[1] = contentViews[2];
    contentViews[2] = contentViews[0];
    contentViews[0] = tmpView;
    
    CGRect frame = ((UIScrollView*)contentViews[1]).frame;
    frame.origin.x += frame.size.width;
    ((UIScrollView*)contentViews[2]).frame = frame;
    [self setContentAtIndex:curIndex+1 contentView:contentViews[2]];
}


-(UIScrollView*)getContentScrollView:(CGRect)frame
{
    UIScrollView* contentView = [[UIScrollView alloc] initWithFrame:frame];
    //        contentView.delegate = self;
    contentView.minimumZoomScale = 1.0f;
    contentView.maximumZoomScale = 2.0f;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.backgroundColor = [UIColor clearColor];
    return contentView;
    
}


-(void)changeAllFrame:(CGRect)_frame
{
    CGRect frame = CGRectZero;
    frame.size = _frame.size;
    frame.origin.x = (curIndex-1) * frame.size.width;
    
    for (int i=0; i < 3; i++) {
        UIScrollView *contentView = contentViews[i];
        contentView.frame = frame;
        frame.origin.x += frame.size.width;
    }
    
}


@end
