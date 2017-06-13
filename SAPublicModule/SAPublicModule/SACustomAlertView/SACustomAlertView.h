//
//  SACustomAlertView.h
//  SAPublicModule
//
//  Created by 李磊 on 13/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol SACustomAlertViewDelegate <NSObject>


/**
 点击按钮粗发事件

 @param states 点击取消还是缺点按钮
 @param myChose 是否 点击不在提示选择框
 */
- (void)ButtonDidClickedWithCancleOrSure:(NSString*)states IsRemberMyChose:(BOOL) myChose ;


@end



@interface SACustomAlertView : UIView


/**
 提示框的View
 */
@property (nonatomic, strong) UIView *customAlertView;


/**
 “提示”label
 */
@property (nonatomic, strong) UILabel *titleLabel;


//@property (nonatomic, strong) UIColor *titleColor;
//
//@property (nonatomic, strong) UIFont *titleFont;



/**
 正文提示文字Label
 */
@property (nonatomic, strong) UILabel *messageLabel;

//@property (nonatomic,strong) UIColor *msgColor;
//@property (nonatomic,strong) UIFont  *msgFont;



/**
 选择是否提示Button
 */
@property (nonatomic, strong) UIButton *selectPromptButton;


/**取消按钮 */
@property (nonatomic,strong) UIButton *cancelButton;
//@property (nonatomic,strong) UIColor  *cancelButtonColor;

/**确定 */
@property (nonatomic,strong) UIButton *sureButton;
//@property (nonatomic,strong) UIColor  *sureButtonColor;

@property (nonatomic, assign) id<SACustomAlertViewDelegate>delegate;

- ( instancetype )initWithFrame:(CGRect)frame withMessage:(NSMutableString *)messageString;


@end
