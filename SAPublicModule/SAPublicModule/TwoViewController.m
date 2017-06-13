//
//  TwoViewController.m
//  SAPublicModule
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "TwoViewController.h"
#import "SACustomAlertView.h"

@interface TwoViewController () <SACustomAlertViewDelegate>



@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 150, 200, 40);
    [button setTitle:@"弹出提示框" forState:0];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark ----- 
- (void)buttonClicked:(UIButton *)sender{
    NSUserDefaults *choser = [NSUserDefaults standardUserDefaults];
    NSString *myChose = [ choser objectForKey:@"userChose"];
    if (![myChose isEqualToString:@"remember"]) {
        SACustomAlertView *alertView = [[SACustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) withMessage:[NSMutableString stringWithFormat:@"“伴儿服务”非内蒙古移动公司的产品，属第三方供应商提供，若因使用本产品产生的一切责任和后果均与内蒙古移动无关，请客户自行选择。一个可以适应孤独，享受孤独，并且能在孤独中学会成长的人，他的灵魂，一定是安静而充实的。所以说，真正的成熟，是稳重而安静，不是想通了很多道理，而是慢慢发现，其实很多事情，本就没有道理可言。未来，再没有十八岁；未来，朋友会渐行渐远；未来，最多的路，还是得靠我们一个人走。"]];
        alertView.delegate = self;
        alertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.7];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        //    [self.view.window addSubview:alertView];
        
    }
    

}

-(void)ButtonDidClickedWithCancleOrSure:(NSString *)states IsRemberMyChose:(BOOL)myChose{
    NSLog(@"%d",myChose);
    
    if ([states isEqualToString:@"cancle"]) {
        //点击取消按钮
        
    }else
    {
        //点击确定按钮  根据存储的内容对以后是否显示该控件进行判断
        if (myChose == YES) {
            //记住我的选择
            //将NSString 对象存储到 NSUserDefaults 中
            NSString *remember = @"remember";
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:remember forKey:@"userChose"];
        }else
        {
            
        }
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
