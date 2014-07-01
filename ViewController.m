//
//  ViewController.m
//  Week_4_HW-2
//
//  Created by Kristina Frost on 6/29/14.
//  Copyright (c) 2014 Kristina Frost. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *drawerScrollView;
@property (weak, nonatomic) IBOutlet UIView *drawerView;
- (IBAction)onPan:(UIPanGestureRecognizer *)sender;
@property (nonatomic) UIImageView *duplicateView;
@property (nonatomic) UIPanGestureRecognizer *stickerPanGesture;
@property (nonatomic) UIPinchGestureRecognizer *stickerPinchGesture;
@property (nonatomic) UIRotationGestureRecognizer *stickerRotateGesture;

- (void)stickerDidPan:(UIPanGestureRecognizer *)panGesture;
- (void)stickerDidPinch:(UIPinchGestureRecognizer *)pinchGesture;
- (void)stickerDidRotate:(UIRotationGestureRecognizer *)rotateGesture;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.drawerScrollView.contentSize = CGSizeMake(640, 70);
    
    self.stickerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPan:)];
    
    self.stickerPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPinch:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.duplicateView = [[UIImageView alloc] init];
        self.duplicateView.image = [(UIImageView *)sender.view image];
        CGRect frame = sender.view.frame;
        frame.size.width = frame.size.width * 5;
        frame.size.height = frame.size.height * 5;
        frame.origin.y += self.drawerScrollView.frame.origin.y;
        self.duplicateView.frame = frame;
        
        [self.view addSubview:self.duplicateView];
        [self.duplicateView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPan:)]];
        [self.duplicateView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPinch:)]];
        [self.duplicateView setUserInteractionEnabled:YES];
        
        
        
    }
    
    
    else if(sender.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        
        self.duplicateView.center = CGPointMake(self.duplicateView.center.x + translation.x, self.duplicateView.center.y + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        //UIImageView *view;
        
    }
    
    
}

- (void)stickerDidPan:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"panning sticker");
    CGPoint translation = [panGesture translationInView:self.view];
    
    if(panGesture.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } if (panGesture.state == UIGestureRecognizerStateEnded) {
        //UIImageView *view;
        
    }
    
    
}

- (void)stickerDidPinch:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"pinching sticker");
    
    // use the scale of the pinchGesture
    CGFloat scale = pinchGesture.scale;
    
    // pinch gesture does not have translation!
    //CGPoint translation = [pinchGesture translationInView:self.view];
    
    if(pinchGesture.state == UIGestureRecognizerStateChanged) {
        
        pinchGesture.view.transform = CGAffineTransformMakeScale(scale, scale);
        
        //pinchGesture.view.center = CGPointMake(pinchGesture.view.center.x + translation.x, pinchGesture.view.center.y + translation.y);
        //[pinchGesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        //UIImageView *view;
        
    }
}

@end
