//
//  CALayer+Addition.m
//  GHBLocationManager
//
//  Created by 123 on 15/12/23.
//  Copyright © 2015年 haibin. All rights reserved.
//

#import "CALayer+Additions.h"

#import <objc/runtime.h>

@implementation CALayer (Additions)


//- (UIColor *)borderColorFromUIColor{
//    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
//}
//- (void)setBorderColorFromUIColor:(UIColor *)color{
//    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self setBorderColorFromUI:self.borderColorFromUIColor];
//}
//- (void)setBorderColorFromUI:(UIColor *)color{
//    self.borderColor = color.CGColor;
//    NSLog(@"%@", color);
//}

- (void)setBorderUIColor:(UIColor *)borderUIColor{
    self.borderColor = borderUIColor.CGColor;
}
- (UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
