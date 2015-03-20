//
//  ViewController.h
//  ChemiGjera
//
//  Created by NextepMac on 11/21/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PopUpView.h"
#import "GAITrackedViewController.h"


@class GADBannerView;

@interface ViewController : GAITrackedViewController<AVAudioPlayerDelegate>
{
    UIButton *curButton;
    BOOL isStoped;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic,retain) NSMutableArray *arr;

@property (weak, nonatomic) IBOutlet UIButton *showPopupBtn;
@property (strong, nonatomic) PopUpView *popViewController;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitle;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end

