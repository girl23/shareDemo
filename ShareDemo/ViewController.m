//
//  ViewController.m
//  ShareDemo
//
//  Created by wdwk on 16/4/27.
//  Copyright © 2016年 wdwk. All rights reserved.
//

#import "ViewController.h"
#import "UMSocial.h"
#import "OptionButton.h"
#import "UIColor+ColorUtil.h"
#import "MCMineTypeButton.h"
@interface ViewController ()

@property (nonatomic, strong) UIButton * shareBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    shareBtn.frame = CGRectMake(50, 100, 100, 50);
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    // 功能键相关
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray *buttonTitles = @[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友", @"QQ空间"];
    NSArray *buttonImages = @[@"tweetEditing", @"picture", @"shooting", @"sound", @"scan"];
    int buttonColors[] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, /*0x61b644,*/ 0xf1c50e};
    
    for (int i = 0; i <5; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2),
                                        _screenHeight + 150 + i/3*100,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        
        optionButton.button.layer.cornerRadius=_length/2;
        optionButton.button.layer.masksToBounds=YES;
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }
    _cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, _screenHeight-35, _screenWidth-10, 30)];
    [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     _cancelBtn.layer.cornerRadius=5;
     _cancelBtn.layer.masksToBounds=YES;
     _cancelBtn.layer.borderColor=[UIColor blackColor].CGColor;
     _cancelBtn.layer.borderWidth=2;
    
    [self.view addSubview:_cancelBtn];
    [self.view bringSubviewToFront:_cancelBtn];
    _cancelBtn.hidden=YES;


}
-(void)cancelButtonClick:(UIButton*)sender
{
    [self shareBtnClicked:nil];
}
-(void)shareType:(NSString *)shareType
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"这是我分享给你的资源额，http://www.eastedu.org/Login" image:[UIImage imageNamed:@"1024x1024.jpg"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
   
}
- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
  switch (recognizer.view.tag) {
     case 0:
          [self shareType:UMShareToWechatSession];
        break;
      case 1:
          [self shareType:UMShareToWechatTimeline];
          break;
      case 2:
          [self shareType:UMShareToSina];
          break;
      case 3:
          [self shareType:UMShareToQQ];
          break;
      case 4:
          [self shareType:UMShareToQzone];
          break;
          
  default:
    break;
          
}
}
- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 5; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 5; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

- (void)addBlurView
{
    _shareBtn.enabled = NO;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = CGRectMake(0, screenSize.height - 270, screenSize.width, screenSize.height);
    
//    UIImage *originalImage = [self.view updateBlur];
//    UIImage *croppedBlurImage = [originalImage cropToRect:cropRect];
//    
//    _blurView = [[UIImageView alloc] initWithImage:croppedBlurImage];
//    _blurView.frame = cropRect;
//    _blurView.userInteractionEnabled = YES;
//    [self.view addSubview:_blurView];
    
    _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimView.backgroundColor = [UIColor blackColor];
    _dimView.alpha = 0.4;
//    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    [_dimView  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
    
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if (finished) {_shareBtn.enabled = YES;}
                     }];
}

- (void)removeBlurView
{
    _shareBtn.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             _dimView = nil;
                             
                             [self.blurView removeFromSuperview];
                             self.blurView = nil;
                            _shareBtn.enabled = YES;
                         }
                     }];
}
-(void)shareBtnClicked:(UIButton*)sender
{
    _cancelBtn.hidden=_isPressed;
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    _isPressed = !_isPressed;
   
}
//代理方法
//点击每个平台后默认会进入内容编辑页面，若想点击后直接分享内容，可以实现下面的回调方法。

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
