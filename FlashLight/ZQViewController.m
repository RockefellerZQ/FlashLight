//
//  ZQViewController.m
//  FlashLight
//
//  Created by Little Treasure on 8/20/13.
//  Copyright (c) 2013 Little_Treasure. All rights reserved.
//

#import "ZQViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZQViewController ()
{
    AVCaptureDevice *cameraFlash;
    BOOL over;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *togView;

@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"OffBg"]]];
    [_togView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Off"]]];
    
    UISwipeGestureRecognizer *upGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnOn:)];
    [upGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    
    UISwipeGestureRecognizer *downGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnDown:)];
    [downGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [_bgView addGestureRecognizer:upGesture];
    [_bgView addGestureRecognizer:downGesture];
    
    upGesture = nil;
    downGesture = nil;
    over = NO;
    cameraFlash = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)turnOn:(UISwipeGestureRecognizer *)gesture
{
    if (!over) {
        [self togViewAnimtaionUp:YES];
        [self flashOn:YES];
    }
    over = YES;
}

- (void)turnDown:(UISwipeGestureRecognizer *)gesture
{
    if (over) {
        [self togViewAnimtaionUp:NO];
        [self flashOn:NO];
    }
    over = NO;
}

- (void)togViewAnimtaionUp:(BOOL)up
{
    CGRect togViewFrame = _togView.frame;
    NSString *bgImage= nil;
    NSString *togImage = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (up) {
        [_togView setFrame:CGRectMake(togViewFrame.origin.x, togViewFrame.origin.y - togViewFrame.size.height, CGRectGetWidth(togViewFrame), CGRectGetHeight(togViewFrame))];
        bgImage = @"OnBg";
        togImage = @"On";
    } else {
        [_togView setFrame:CGRectMake(togViewFrame.origin.x, togViewFrame.origin.y + togViewFrame.size.height, CGRectGetWidth(togViewFrame), CGRectGetHeight(togViewFrame))];
        bgImage = @"OffBg";
        togImage = @"Off";
    }
    [_bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgImage]]];
    [_togView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:togImage]]];
    [UIView commitAnimations];
   
    bgImage = nil;
    togImage = nil;
}

- (void)flashOn:(BOOL)On
{
    if ([cameraFlash isTorchAvailable] && [cameraFlash isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [cameraFlash lockForConfiguration:nil];
        
        if (success) {
            switch (On) {
                case YES:
                    [cameraFlash setTorchMode:AVCaptureTorchModeOn];
                    break;
                case NO:
                    [cameraFlash setTorchMode:AVCaptureTorchModeOff];
                    break;
                default:
                    break;
            }
            [cameraFlash unlockForConfiguration];
        }
    }
}

@end
