//
//  ViewController.m
//  LXPageView
//
//  Created by Leexin on 17/3/17.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Extensions.h"
#import "UIView+Extensions.h"
#import "LXPageView.h"

@interface ViewController ()
@property (nonatomic, strong) LXPageView *pageView1;
@property (nonatomic, strong) LXPageView *pageView2;
@property (nonatomic, strong) LXPageView *pageView3;
@property (nonatomic, strong) LXPageView *pageView4;
@property (nonatomic, strong) LXPageView *pageView5;
@property (nonatomic, strong) LXPageView *pageView6;
@property (nonatomic, assign) BOOL isFoward;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.isFoward = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.height - 100.f) / 2, self.view.width, 100.f)];
    bgView.backgroundColor = [UIColor colorWithHex:0x1E90FF];
    [self.view addSubview:bgView];
    
    self.pageView1 = [[LXPageView alloc] initWithFrame:CGRectMake(0, 20.f, 80.f, 60.f) style:LXPageViewStyleLineMove pageCount:4];
    [bgView addSubview:self.pageView1];
    
    self.pageView2 = [[LXPageView alloc] initWithFrame:CGRectMake(80, 20.f, 80.f, 60.f) style:LXPageViewStyleCircleExchange pageCount:4];
    [bgView addSubview:self.pageView2];
    
    self.pageView3 = [[LXPageView alloc] initWithFrame:CGRectMake(160, 20.f, 80.f, 60.f) style:LXPageViewStyleHollowCircleMove pageCount:4];
    [bgView addSubview:self.pageView3];
    
    self.pageView4 = [[LXPageView alloc] initWithFrame:CGRectMake(240, 20.f, 80.f, 60.f) style:LXPageViewStyleCircleRotate pageCount:4];
    [bgView addSubview:self.pageView4];
//    
//    self.pageView5 = [[LXPageView alloc] initWithFrame:CGRectMake(0, 20.f, 80.f, 60.f) style:LXPageViewStyleHollowCircle pageCount:4];
//    [bgView addSubview:self.pageView5];
//    
//    self.pageView6 = [[LXPageView alloc] initWithFrame:CGRectMake(0, 20.f, 80.f, 60.f) style:LXPageViewStyleHollowCircle pageCount:4];
//    [bgView addSubview:self.pageView6];
    
    
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(60.f, bgView.bottom + 20.f, self.view.width - 120.f, 30.f);
    [changeButton setTitle:@"Change" forState:UIControlStateNormal];
    [changeButton setTintColor:[UIColor whiteColor]];
    [changeButton addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:changeButton];
}

- (void)onButtonClick {
    
    NSLog(@"》》》》》》》》》》》 Change 》》》》》》》》》》》》》》》 \n");
    [self changePage:self.pageView1];
    [self changePage:self.pageView2];
    [self changePage:self.pageView3];
    [self changePage:self.pageView4];
//    [self changePage:self.pageView5];
//    [self changePage:self.pageView6];
//    [self changePage:self.pageView7];
//    [self changePage:self.pageView8];
}

- (void)changePage:(LXPageView *)pageView {
    
    if (pageView.currentPage >= 3) {
        pageView.currentPage = 0;
    } else {
        pageView.currentPage += 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
