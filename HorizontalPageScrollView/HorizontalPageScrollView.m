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
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        curIndex = 0;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        contentViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    count = [_datasource numberInView];
    [self setUpView];
}

-(void)setUpView
{
    CGRect frame = CGRectZero;
    frame.size = self.frame.size;
    frame.origin.x = (curIndex-1) * frame.size.width;
    
    for (int i=0; i < 3; i++) {
        UIScrollView *contentView = [self getContentScrollView:frame];
        [self addSubview:contentView];
        [contentViews addObject:contentView];
        frame.origin.x += frame.size.width;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width * count,self.frame.size.height);
    [self setContentAtIndex:curIndex-1 contentView:contentViews[0]];
    [self setContentAtIndex:curIndex   contentView:contentViews[1]];
    [self setContentAtIndex:curIndex+1 contentView:contentViews[2]];
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
    [scrollView addSubview: [_datasource viewAtIndex:index]];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isEqual:self]) return;
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

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [[scrollView subviews] objectAtIndex:0];
}



@end
