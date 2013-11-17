//
//  HorizontalPageScrollView.h
//  HorizontalPageScrollView
//
//  Created by kitano on 2013/11/16.
//  Copyright (c) 2013年 kitano. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HorizontalPageScrollViewDateSource <NSObject>
-(int)numberInView;
-(UIView*)viewAtIndex:(int)index;

@end
@interface HorizontalPageScrollView : UIScrollView
<UIScrollViewDelegate>

@property (nonatomic,retain) id<HorizontalPageScrollViewDateSource> datasource;

@end
