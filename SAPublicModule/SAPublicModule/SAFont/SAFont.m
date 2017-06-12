//
//  SAFont.m
//  SAPublicModule
//
//  Created by 李磊 on 12/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SAFont.h"
#import <objc/runtime.h>

static NSString *const kHelveticaNeueLightFont = @"HelveticaNeue-Light";


@interface UIFont (MyFont)      @end



@implementation UIFont (MyFont)

+ (void)load{
    
    Method imp = class_getClassMethod([self class], @selector(systemFontOfSize:));
    Method myImp = class_getClassMethod([self class], @selector(mySystemFontOfSize:));
    method_exchangeImplementations(imp, myImp);
}

+ (id)mySystemFontOfSize:(CGFloat)size{
    
    UIFont *font = [UIFont mySystemFontOfSize:size];
    if (font) {
        font = [UIFont fontWithName:kHelveticaNeueLightFont size:size];
    }
    return font;
}

@end
