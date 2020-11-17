//
//  BaseViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/29.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "BaseViewController.h"
#import "UIColor+RandomColor.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *darkColor;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customBackgroundColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self ue_barTintColor]};
}

- (UIColor *)ue_barTintColor {
    return [UIColor customTitleColor];
}

- (UIColor *)ue_shadowImageTintColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor lightGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
    }];
}

#pragma mark - Getter
- (UIColor *)lightColor {
    if (!_lightColor) {
        _lightColor = [UIColor randomLightColor];
    }
    return _lightColor;
}

- (UIColor *)darkColor {
    if (!_darkColor) {
        _darkColor = [UIColor randomDarkColor];
    }
    return _darkColor;
}

- (UIColor *)randomColor {
    if (!_randomColor) {
        _randomColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return self.lightColor;
        } darkModeColor:^UIColor * _Nonnull{
            return self.darkColor;
        }];
    }
    return _randomColor;
}

@end
