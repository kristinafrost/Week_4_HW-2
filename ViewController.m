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
    
    self.stickerRotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidRotate:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.duplicateView = [[UIImageView alloc] init];
        self.duplicateView.image = [(UIImageView *)sender.view image];
        CGRect frame = CGRectMake(0, 0, sender.view.frame.size.width * 5, sender.view.frame.size.height * 5);
        
        NSLog(@"scroll x offset %f",self.drawerScrollView.contentOffset.x);
        //frame.origin.y += self.drawerScrollView.frame.origin.y;
        //frame.origin.x = frame.origin.x - self.drawerScrollView.contentOffset.x;
        self.duplicateView.frame = frame;
        self.duplicateView.center = location;
        
        [self.view addSubview:self.duplicateView];
        
        [self.duplicateView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPan:)]];
        [self.duplicateView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPinch:)]];
        [self.duplicateView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidRotate:)]];
        
        [self.duplicateView setUserInteractionEnabled:YES];
        
        
        
    }
    
    
    else if(sender.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        
        self.duplicateView.center = CGPointMake(self.duplicateView.center.x + translation.x, self.duplicateView.center.y + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        
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

        
        [self.view bringSubviewToFront:self.drawerScrollView];
        
        
    }
    
    
}

- (void)stickerDidPinch:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"pinching sticker");
    
    // use the scale of the pinchGesture
    CGFloat scale = pinchGesture.scale;
    
    
    if(pinchGesture.state == UIGestureRecognizerStateChanged) {
        
        pinchGesture.view.transform = CGAffineTransformMakeScale(scale, scale);
        //CGAffineTransform myTransform = CGA
        
     
        
    } if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        
    }

}

- (void)stickerDidRotate:(UIRotationGestureRecognizer *)rotateGesture {
    
    CGFloat rotate = rotateGesture.rotation;
    
    
    if(rotateGesture.state == UIGestureRecognizerStateChanged) {
        
        rotateGesture.view.transform = CGAffineTransformMakeRotation(rotate);
        
        
    } if (rotateGesture.state == UIGestureRecognizerStateEnded) {
        
    }
    
}



@end
