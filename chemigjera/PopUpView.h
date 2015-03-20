//
//  PopUpViewController.h
//  ChemiGjera
//
//  Created by NextepMac on 12/4/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface PopUpView : UIViewController{
    int offset;
    CGSize screenSize;
}


@property(nonatomic,retain) UIView *popUpView;

@property (nonatomic, assign) BOOL opened;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)removeAnimate;

@end