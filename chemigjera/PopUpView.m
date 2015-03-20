//
//  PopUpViewController.m
//  ChemiGjera
//
//  Created by NextepMac on 12/4/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "PopUpView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface PopUpView ()

@end

@implementation PopUpView

@synthesize popUpView;

@synthesize opened;


- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
    }];
    
    return urlWasHandled;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


- (void)clickShare:(id)sender{
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"http://nextep.ge/doYouBelieveMe/about"];
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithLink:params.link
        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        if(error) {
            NSLog(@"Error publishing story: %@", error.description);
            } else {
                NSLog(@"result %@", results);
            }
        }];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
        handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            NSLog(@"Error publishing story: %@", error.description);
            } else {
                if (result == FBWebDialogResultDialogNotCompleted) {
                    NSLog(@"User cancelled.");
                } else {
                    NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                    if (![urlParams valueForKey:@"post_id"]) {
                        NSLog(@"User cancelled.");
                                                                  
                    } else {
                        NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                        NSLog(@"result %@", result);
                    }
                }
            }
        }];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint pos = [touch locationInView: [UIApplication sharedApplication].keyWindow];
    if(pos.y > screenSize.height/3 + offset){
        [self removeAnimate];
    }
}

- (void)clickSub:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/user/shenchemigjera/videos"]];
}


- (void)addButtons{
    FBLikeControl *like = [[FBLikeControl alloc] init];
    like.objectID = @"https://www.facebook.com/pages/ჩემი-გჯერა/705006389587133?fref=ts";
    like.likeControlStyle = FBLikeControlStyleButton;
    like.frame = CGRectMake(screenSize.width * 3/4, screenSize.height/10, 60, 60);
    [self.view addSubview:like];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage = [UIImage imageNamed:@"share.png"];
    [share setBackgroundImage:buttonImage forState:UIControlStateNormal];
    share.frame = CGRectMake(screenSize.width * 3/4, screenSize.height/6, 70, 27);
    [self.view addSubview:share];
    
    UIButton *sub = [UIButton buttonWithType:UIButtonTypeCustom];
    [sub addTarget:self action:@selector(clickSub:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonImage1 = [UIImage imageNamed:@"subscrabe.png"];
    [sub setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    sub.frame = CGRectMake(screenSize.width * 3/4, screenSize.height/4 - 8, 70, 27);
    [self.view addSubview:sub];

}


- (void)addLabels{
    int textSize;
    int top;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        textSize = 25;
        top = 30;
    }
    else{
        textSize = 14;
        top = 0;
    }
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width/3 - 20, top, 500, 50)];
    label1.text = @"მეტი მხიარულება გსურს?";
    label1.textColor = [UIColor yellowColor];
    label1.font = [UIFont fontWithName:@"BPGRioni" size:textSize];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, screenSize.height/10, 500, 25)];
    label2.text = @"შემოგვიერთდი ფეისბუქზე!";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont fontWithName:@"BPGRioni" size:textSize];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, screenSize.height/6, 500, 25)];
    label3.text = @"გაუზიარე მეგობრებს!";
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont fontWithName:@"BPGRioni" size:textSize];
    [self.view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, screenSize.height/4- 8, 500, 25)];
    label4.text = @"შემოგვიერთდი იუთუბიზე!";
    label4.textColor = [UIColor whiteColor];
    label4.font = [UIFont fontWithName:@"BPGRioni" size:textSize];
    [self.view addSubview:label4];
}


- (void)viewDidLoad
{
    opened = YES;
    offset = 64;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    self.view.frame = CGRectMake(0, offset, screenSize.width, screenSize.height);
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height/3)];
    [imageHolder setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0]];
    [self.view addSubview:imageHolder];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [self addButtons];
    [self addLabels];
    [self.view setMultipleTouchEnabled:YES];
    [super viewDidLoad];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    opened = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popUpClosed" object:nil];

    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end