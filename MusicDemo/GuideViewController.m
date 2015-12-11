//
//  GuideViewController.m
//  musicPlayer
//
//  Created by qingyun on 15/11/27.
//  Copyright (c) 2015年 阿六. All rights reserved.
//

#import "GuideViewController.h"
#import "CYJPlayingViewController.h"
#import "CYJMusicList.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createPageControl];
    // Do any additional setup after loading the view.
}

- (void)createScrollView
{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate=self;
    //设置scrollView的内容大小
    scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*3, 667);
    //设置分页
    scrollView.pagingEnabled=YES;
    //去掉滚动条
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    //取消反弹效果
    scrollView.bounces=NO;
    //设置图片的大小
    CGFloat width=self.view.bounds.size.width;
    CGFloat height=self.view.bounds.size.height;
    [self.view addSubview:scrollView];
    
    for (int i=0; i<3; i++) {
        UIImageView *pageImage=[[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [pageImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_%d",i+1]]];
        if (i == 2) {
            [self createBtn:pageImage];
        }
        [scrollView addSubview:pageImage];
    }
}

- (void) createBtn:(UIImageView *)pageImage
{
    [pageImage setUserInteractionEnabled:YES];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(150, 450, 64, 64)];
    [pageImage addSubview:btn];
    UIImage *image=[UIImage imageNamed:@"iconfont-confirm"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick
{

//    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    CYJPlayingViewController *playVC=[story instantiateViewControllerWithIdentifier:@"music"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CYJMusicList *list = [story instantiateViewControllerWithIdentifier:@"musicList"];
    
    [self presentViewController:list animated:YES completion:nil];
}

- (void)createPageControl
{
    _pageControl=[[UIPageControl alloc] init];
    [_pageControl setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height*0.9)];
    [_pageControl setBounds:CGRectMake(0, 0, 375, 44)];
    _pageControl.numberOfPages=3;
    _pageControl.pageIndicatorTintColor=[UIColor blackColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    [self.view addSubview:_pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index=scrollView.contentOffset.x/scrollView.bounds.size.width;
    _pageControl.currentPage=index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
