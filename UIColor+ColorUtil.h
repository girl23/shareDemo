//
//  UIColor+ColorUtil.h
//  ShareDemo
//
//  Created by wdwk on 16/5/6.
//  Copyright © 2016年 wdwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorUtil)
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;
@end
