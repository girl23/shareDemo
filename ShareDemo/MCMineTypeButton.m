//
//  MCMineTypeButton.m
//  MicroClassroom
//
//  Created by Listen on 16/5/17.
//  Copyright © 2016年 FeiGuangpu. All rights reserved.
//

#import "MCMineTypeButton.h"

@implementation MCMineTypeButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
       [self setFont:[UIFont systemFontOfSize:13.0f]];
       [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)layoutSubviews
{
//    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    
//    CGFloat leftRightMargin = (self.width - self.imageView.width - 13 - self.titleLabel.width) / 2;
//    self.imageView.left = leftRightMargin;
//    self.imageView.top = (self.height - self.imageView.height) / 2;
//    
//    self.titleLabel.left = self.imageView.right + 13;
//    self.titleLabel.top = (self.height - self.titleLabel.height) / 2;
    
    
//    CGFloat leftRightMargin=self.imageView.width>self.titleLabel.width?(self.width-self.imageView.width)/2:(self.width-self.titleLabel.width)/2;
//    self.frame.size.height;
//    self.frame.size.width;
//    CGFloat topMargin=(self.frame.size.height-self.imageView.frame.size.height-self.titleLabel.frame.size.height-13)/2;
//    
//    CGFloat left=self.frame.size.width-self.imageView.frame.size.width;
//    CGFloat top=topMargin;
//    self.imageView.frame=CGRectMake(left, top, self.imageView.frame.size.width, self.imageView.frame.size.height);
//    
//   
//     CGFloat left1=self.frame.size.width-self.titleLabel.frame.size.width;
//     CGFloat top1=self.frame.size.height-topMargin-self.imageView.frame.size.height-13;
//     self.titleLabel.frame=CGRectMake(left1, top1, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

@end
