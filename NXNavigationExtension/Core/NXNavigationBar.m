//
// NXNavigationBar.m
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NXNavigationBar.h"


@interface NXNavigationBar ()

@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@implementation NXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _originalNavigationBarFrame = CGRectZero;
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentViewEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backgroundEffectView.hidden = YES;
        _blurEffectEnabled = NO;
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backgroundEffectView];
        [self addSubview:self.shadowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateNavigationBarFrame:self.frame callSuper:NO];
}

- (void)setFrame:(CGRect)frame {
    [self updateNavigationBarFrame:frame callSuper:YES];
}

#pragma mark - Private

- (void)setBlurEffectEnabled:(BOOL)blurEffectEnabled {
    _blurEffectEnabled = blurEffectEnabled;
    [self setBackgroundColor:self.originalBackgroundColor];
}

/// 更新导航栏 frame
/// @param callSuper 是否需要调用 super setFrame: 方法
- (void)updateNavigationBarFrame:(CGRect)frame callSuper:(BOOL)callSuper {
    CGRect navigationBarFrame = CGRectMake(0, 0, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame));
    self.backgroundEffectView.frame = navigationBarFrame;
    self.backgroundImageView.frame = navigationBarFrame;
    
    CGRect contentViewFrame = CGRectMake(0, CGRectGetMinY(_originalNavigationBarFrame), CGRectGetWidth(_originalNavigationBarFrame), CGRectGetHeight(_originalNavigationBarFrame));
    self.contentView.frame = UIEdgeInsetsInsetRect(contentViewFrame, _contentViewEdgeInsets);
    
    CGFloat shadowImageViewHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, CGRectGetMaxY(_originalNavigationBarFrame) - shadowImageViewHeight, CGRectGetWidth(navigationBarFrame), shadowImageViewHeight);
    
    // 放在所有的 View 前面，防止 contentView 被遮挡
    if (self.superview && self.superview != self.contentView && self.superview != self.contentView.superview) {
        [self.superview addSubview:self.contentView];
    }
    [self.superview bringSubviewToFront:self.contentView];
    
    // 重新设置 NavigationBar frame
    if (callSuper) {
        CGFloat navigationBarY = CGRectGetMinY(frame) - CGRectGetMinY(_originalNavigationBarFrame);
        [super setFrame:CGRectMake(0, navigationBarY, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame))];
    }
}

#pragma mark - Public

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.originalBackgroundColor = backgroundColor;
    if (self.blurEffectEnabled) {
        self.backgroundImageView.hidden = YES;
        self.backgroundEffectView.hidden = NO;
        self.backgroundEffectView.contentView.backgroundColor = backgroundColor;
        
        [super setBackgroundColor:[UIColor clearColor]];
    } else {
        self.backgroundImageView.hidden = NO;
        self.backgroundEffectView.hidden = YES;
        
        [super setBackgroundColor:backgroundColor];
    }
}

- (void)setContentViewEdgeInsets:(UIEdgeInsets)contentViewEdgeInsets {
    _contentViewEdgeInsets = contentViewEdgeInsets;
    [self updateNavigationBarFrame:self.frame callSuper:NO];
}

@end
