//
//  ViewController.m
//  HorizontalPageScrollView
//
//  Created by kitano on 2013/11/16.
//  Copyright (c) 2013年 kitano. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *imageFiles;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    imageFiles = [NSArray arrayWithObjects:
                  [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"],
                  [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                  [[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"],
                  nil];

    
    HorizontalPageScrollView *hc = [[HorizontalPageScrollView alloc] initWithFrame:self.view.frame];
    hc.datasource = self;
    [self.view addSubview:hc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//start pos
-(int)startIndex:(HorizontalPageScrollView*)scrollView
{
    return 1;
}

-(int)numberInView:(HorizontalPageScrollView*)scrollView;
{
    return [imageFiles count];
}
-(UIView*)viewAtIndex:(int)index scrollView:(HorizontalPageScrollView*)scrollView;
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage* image = [UIImage imageWithContentsOfFile:[imageFiles objectAtIndex:index]];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = (image.size.width > image.size.height) ?
    UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
    return  imageView;
}


@end
