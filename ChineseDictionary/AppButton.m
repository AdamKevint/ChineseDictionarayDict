//
/***************************************************************
 *       ___       ______        ___         ____     ____      *
 *      / __ \    |  ___  \     / __ \      |  _ \   / _  |     *
 *     / /__\ \   | |    \ |   / /__\ \     | | \ \_/ / | |     *
 *    / ______ \  | |____/ |  / ______ \    | |  \___/  | |     *
 *   /_/      \_\ |_______/  /_/      \_\   |_|         |_|     *
 *                                                              *
 *********************about.me/adam_kevint**********************/
//  AppButton.m
//  AppManage
//
//  Created by chen on 13-5-29.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import "AppButton.h"

@implementation CAppButton

+ (CAppButton*)BtnWithType:(UIButtonType)buttonType
{
    CAppButton *btn = [CAppButton buttonWithType:buttonType];
	btn.backgroundColor=[UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
	return bounds;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
	return bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(contentRect.origin.x, contentRect.origin.y + contentRect.size.height/5*3, contentRect.size.width, contentRect.size.height/5*2);
}

- (CGRect)imageRectForContentRect:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height/5*3);
}

@end
