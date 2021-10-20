//
//  ViewController08_CustomBackButton.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController08_CustomBackButton.h"
#import "UIColor+RandomColor.h"

@interface ViewController08_CustomBackButton ()

@end

@implementation ViewController08_CustomBackButton

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)nx_backButtonCustomView {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"😋" forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"NavigationBarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    return backButton;
}

@end
