//
//  SACollectionViewGridLayout.h
//  SAPrivateView
//
//  Created by 李磊 on 25/5/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACollectionViewGridLayout : UICollectionViewLayout

/**
 行间距
 */
@property (nonatomic) CGFloat minimumLineSpacing;


/**
 item间距
 */
@property (nonatomic) CGFloat minimumInteritemSpacing;

/**
 item大小
 */
@property (nonatomic) CGSize itemSize;


/**
 上左下右间隔
 */
@property (nonatomic) UIEdgeInsets sectionInset;


/**
 初始化
 */
- (instancetype)init;
@end
