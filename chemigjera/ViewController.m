//
//  ViewController.m
//  ChemiGjera
//
//  Created by NextepMac on 11/21/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "GADBannerView.h"
#import "GADRequest.h"
#import "Reachability.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize arr;
@synthesize audioPlayer;
@synthesize showPopupBtn;
@synthesize background;
@synthesize imgIcon;


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)normal{
    UIImage *buttonImage = [[UIImage imageNamed:@"soundBtn_Out.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [curButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [curButton addSubview:curButton.titleLabel];
    curButton = nil;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self normal];
}


- (void)touchDownHandler:(id)sender{
    UIButton * button = (UIButton *)sender;
    
    if (curButton == nil)
    {
        curButton = button;
        [self playButton:curButton];
    }
    else
    if ([curButton isEqual:button])
    {
        [audioPlayer stop];
        isStoped = YES;
        UIImage *buttonImage = [UIImage imageNamed:@"soundBtn_Stop.png"];
        [curButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    else
    {
        [self normal];
        curButton = button;
        [self playButton:curButton];
    }
}


- (void)touchUpHandler:(id)sender
{
    if (isStoped)
    {
        [self normal];
        isStoped = NO;
    }
}

-(void)playButton:(UIButton*)button
{
    int index = (int)button.tag;
    NSString * url = [[arr objectAtIndex:index] valueForKey:@"url"];
    NSRange needleRange = NSMakeRange(0, (url.length - 4));
    NSString *title = [url substringWithRange:needleRange];
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:title ofType:@"mp3"];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    audioPlayer.delegate = self;
    UIImage * btnImage2 = [UIImage imageNamed:@"soundBtn_Over.png"];
    [button setBackgroundImage:btnImage2 forState:UIControlStateNormal];
    [button.titleLabel removeFromSuperview];
    [audioPlayer play];
}

- (void)sortWithIndex:(NSArray*) array{
    arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < array.count; i++){
        NSDictionary * temp = [array objectAtIndex:i];
        int index =[[temp valueForKey:@"index"] intValue] - 1;
        [arr insertObject:temp atIndex:index];
    }
}


- (IBAction)showPopUp:(id)sender {
    if(self.popViewController.opened){
        [self.popViewController removeAnimate];
    }
    else {
        self.popViewController = [PopUpView alloc];
        [self.popViewController setTitle:@"This is a popup view"];
        [self.popViewController showInView:self.view animated:YES];
        UIImage *buttonImage = [UIImage imageNamed:@"smileOver.png"];
        [self.showPopupBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
}

- (void)setRoundedBorder:(float)radius borderWidth:(float)borderWidth color:(UIColor*)color forButton:(UIButton *)button
{
    CALayer * l = [button layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:borderWidth];
    [l setBorderColor:[color CGColor]];
}


- (void)viewButtons:(NSArray*) array{
    int space = 4;
    int n = array.count;
    int columns = 3;
    int offset = 64;
    int end;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        end = 95;
    }
    else{
        end = 55;
    }
    
    double width = (screenSize.width - (columns + 1) * space)/columns;
    int rows = 0;
    if(n%columns == 0)
        rows = n/columns;
    else
        rows = n/columns + 1;
    double height = (screenSize.height - (rows+1)*space - offset - end)/rows;
    [self sortWithIndex:array];
    
    
    for(int i = 0; i < n; i++)
    {
        NSDictionary * temp = [arr objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      
        UIImage *buttonImage = [[UIImage imageNamed:@"soundBtn_Out.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        NSString *title = [temp valueForKey:@"name"];
        [button setTitle:title forState:UIControlStateNormal];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            button.titleLabel.font=[UIFont fontWithName:@"BPGRioni" size:25];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        }
        else{
            button.titleLabel.font=[UIFont fontWithName:@"BPGRioni" size:14];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        }
        button.titleLabel.numberOfLines = 0;
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitleColor:[UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(touchUpHandler:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(touchDownHandler:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake((space*(i%columns + 1) + width*(i%columns)), offset +(space*(i/columns + 1)+height*(i/columns)), width, height);
        [self.view addSubview:button];
        
    }
    FBLikeControl *like = [[FBLikeControl alloc] init];
    like.objectID = @"https://www.facebook.com/pages/ჩემი-გჯერა/705006389587133?fref=ts";
    like.likeControlStyle = FBLikeControlStyleButton;
    like.frame = CGRectMake(screenSize.width - 80, offset - 38, 60, 60);
    [self.view addSubview:like];
   
}

- (void)changeButton:(NSNotification *)note {
    UIImage *buttonImage = [UIImage imageNamed:@"smileOut.png"];
    [self.showPopupBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isStoped = NO;
    curButton = nil;
    [self.background setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0]];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
       [self.imgIcon setImage:[UIImage imageNamed:@"chemigjera.png"]];
    }
    else{
        
        GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        bannerView_.adUnitID = @"ca-app-pub-8635991207991290/6903907769";
        bannerView_.rootViewController = self;
        bannerView_.frame = CGRectMake( 0,
                                   self.view.frame.size.height - bannerView_.frame.size.height,
                                   bannerView_.frame.size.width,
                                   bannerView_.frame.size.height );
    
        bannerView_.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleRightMargin;

  
        // Enable test ads on simulators.
        [self.view addSubview:bannerView_];
    
    
        // Initiate a generic request to load it with an ad.
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           nil];
        [bannerView_ loadRequest:request];
    }
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:showPopupBtn];
    
    self.imageViewTitle.image = [UIImage imageNamed:@"title.png"];
    [self.imageViewTitle setFrame:CGRectMake(0, 0, 100, 100)];
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"smileOut.png"];
    [self.showPopupBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    self.showPopupBtn.layer.borderWidth = 0;

 
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeButton:)
                                                name:@"popUpClosed" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary * json = nil;
        if(data){
            json = [NSJSONSerialization
                    JSONObjectWithData:data options:kNilOptions error:nil];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self viewButtons:(NSArray*)json];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"chemigjera";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
