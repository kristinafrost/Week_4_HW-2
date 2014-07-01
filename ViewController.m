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
- (IBAction)onDrawerPan:(UIPanGestureRecognizer *)sender;

- (void)stickerDidPan:(UIPanGestureRecognizer *)panGesture;
- (void)stickerDidPinch:(UIPinchGestureRecognizer *)pinchGesture;
- (void)stickerDidRotate:(UIRotationGestureRecognizer *)rotateGesture;

@end

@implementation ViewController

float startingPanYPosition;
float distancePanned;
float currentSwipeViewYPosition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.drawerScrollView.contentSize = CGSizeMake(640, 70);
    
    self.stickerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPan:)];
    
    self.stickerPinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidPinch:)];
    
    self.stickerRotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(stickerDidRotate:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer == self.drawerScrollView.panGestureRecognizer) {
        return YES;
    }
    return NO;
    
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.duplicateView = [[UIImageView alloc] init];
        self.duplicateView.image = [(UIImageView *)sender.view image];
        CGRect frame = CGRectMake(0, 0, sender.view.frame.size.width * 3, sender.view.frame.size.height * 3);
        
        NSLog(@"scroll x offset %f",self.drawerScrollView.contentOffset.x);
        
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

- (IBAction)onDrawerPan:(UIPanGestureRecognizer *)sender {
    
        CGPoint point = [sender locationInView:self.view];
        CGPoint velocity = [sender velocityInView:self.view];
        
        CGRect frame = self.drawerView.frame;
        
        //news horizontally scrolls!
        self.drawerScrollView.contentSize = self.drawerView.frame.size;
        [self.drawerScrollView setScrollEnabled:true];
        
        
        //begin panning stuffs
        if (sender.state == UIGestureRecognizerStateBegan) {
            float startingHeight = self.drawerView.frame.origin.y;
            startingPanYPosition = point.y;
            currentSwipeViewYPosition = startingHeight;
            
        }
        
        //panning continues stuffs
        else if (sender.state == UIGestureRecognizerStateChanged) {
            
            distancePanned = point.y - startingPanYPosition;
            frame.origin.y = currentSwipeViewYPosition + distancePanned;
            
            if (frame.origin.y > 500) {
                frame.origin.y = 500;
            }
            
            //if (frame.origin.y < 0) {
                frame.origin.y = frame.origin.y/100;
            //}
            
            self.drawerView.frame = frame;
            
        }
        
        //panning ends stuffs
        else if (sender.state == UIGestureRecognizerStateEnded) {
            
            if (velocity.y >= 0) {
                frame.origin.y = 500;
                [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0 options:0
                                 animations:^{
                                     self.drawerView.frame = frame;
                                 } completion:nil];
            }
            
            else if (velocity.y <= 0) {
                frame.origin.y = 0;
                [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:0 options:0
                                 animations:^{
                                     self.drawerView.frame = frame;
                                 } completion:nil];
                
            }
            
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
