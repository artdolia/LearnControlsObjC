//
//  ADViewController.m
//  L26_controls
//
//  Created by A D on 1/25/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ADViewController.h"

@interface ADViewController ()


@property (strong, nonatomic) NSArray *imagesLeftToRight;
@property (strong, nonatomic) NSArray *imagesRightToLeft;

@property (assign, nonatomic) CGPoint player1Home;
@property (assign, nonatomic) CGPoint player2Home;

@property (weak, nonatomic) UIImageView *playerTurn;

@property (assign, nonatomic) CGFloat rotationDegree;
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) CGFloat animationScale;
@property (assign, nonatomic) CGAffineTransform defaultTransform;

@property (strong, nonatomic) NSArray *balls;


@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *manLeftMost    = [UIImage imageNamed:@"Left_most.png"];
    UIImage *manLeft        = [UIImage imageNamed:@"Left.png"];
    UIImage *manMid         = [UIImage imageNamed:@"Mid.png"];
    UIImage *manRight       = [UIImage imageNamed:@"Right.png"];
    UIImage *manRightMost   = [UIImage imageNamed:@"Right_most.png"];
    UIImage *field          = [UIImage imageNamed:@"Field.png"];
    UIImage *realBall       = [UIImage imageNamed:@"real_ball.png"];
    UIImage *cabBall        = [UIImage imageNamed:@"cabage_ball.png"];
    UIImage *fireBall       = [UIImage imageNamed:@"Ball.png"];
    
    self.imagesLeftToRight = [NSArray arrayWithObjects:manLeftMost, manLeft, manMid, manRight, manRightMost, nil];
    self.imagesRightToLeft = [NSArray arrayWithObjects:manRightMost, manRight, manMid, manLeft, manLeftMost, nil];
    
    self.balls = [NSArray arrayWithObjects:cabBall, realBall, nil];
    
    self.powerSlider.transform = CGAffineTransformRotate(self.powerSlider.transform, 270.0/90*M_PI);
    
    self.animationDuration = self.powerSlider.value;
    self.defaultTransform = self.ballView.transform;
    
    self.player1Home = self.playerOneView.center;
    self.player2Home = self.playerTwoView.center;
    
    [self.powerSlider setThumbImage:fireBall forState:UIControlStateNormal];
    [self.heightSlider setThumbImage:fireBall forState:UIControlStateNormal];
    
    [self.fieldView setImage:field];
    [self.ballView setImage:[self.balls objectAtIndex:[self.ballTypeControl selectedSegmentIndex]]];
    [self.playerOneView setImage:manLeftMost];
    [self.playerTwoView setImage:manRightMost];
    
    self.playerOneView.center = self.player1Home;
    self.playerTwoView.center = self.player2Home;
    
    self.playerTurn = self.playerOneView;
    
    [self.view bringSubviewToFront:self.ballView];
    

}


- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if([self.startSwitch isOn]){
        
        [self startAnimation];
    }
}


#pragma mark - Animations

- (void) startAnimation{
    CGPoint ballDestination = [self ballDestinationPointWithPlayerTurn:self.playerTurn];
    
    UIImageView *secondPlayer = [self.playerTurn isEqual:self.playerOneView] ? self.playerTwoView : self.playerOneView;
    
    [self animateView:self.playerTurn
           withImages:[self.playerTurn isEqual:self.playerOneView] ? self.imagesLeftToRight : self.imagesRightToLeft
          andDuration:self.animationDuration * 0.3
        andRepeaCount:1];
    
    [self movePlayer:self.playerTurn
             toPoint:[self player:self.playerTurn destinationPointWithPlayerTurn:self.playerTurn andBallDestination:ballDestination]
        withDuration:self.animationDuration * 0.7
            andDelay:self.animationDuration / 3
             options:UIViewAnimationCurveEaseOut]; //| UIViewAnimationOptionOverrideInheritedOptions];
    
    [self movePlayer:secondPlayer
             toPoint:[self player:secondPlayer destinationPointWithPlayerTurn:self.playerTurn andBallDestination:ballDestination]
        withDuration:self.animationDuration * 0.7
            andDelay:self.animationDuration / 3
             options:UIViewAnimationCurveEaseOut]; //| UIViewAnimationOptionOverrideInheritedOptions];
    
    self.ballView.transform = self.defaultTransform;
    
    [UIView animateWithDuration:self.animationDuration *0.29f
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionOverrideInheritedOptions |
                                UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionRepeat
                     animations:^{
 
                         CGAffineTransform scale = CGAffineTransformMakeScale(self.heightSlider.value, self.heightSlider.value);
                         /*
                         CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
                         CGAffineTransform final = CGAffineTransformConcat(rotation, scale);
                         */
                         self.ballView.transform = scale;
                         
                        [self.rotateSwitch isOn] ? ([self startRotationWithDegree:arc4random()%2 ? M_PI *-4: M_PI *4]) : nil;
                         
                     } completion:^(BOOL finished) {
                     }];

    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDuration/20
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
        
                         self.ballView.center = ballDestination;
                        
        //CGAffineTransform rotate = CGAffineTransformMakeRotation(self.rotationDegree);
        //self.ballView.transform = rotate;
                        
        /*
        [UIView transitionWithView:self.ballView
                          duration:self.animationDuration * 0.29f
                           options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionRepeat
                        animations:^{
     
                            NSLog(@"height = %f", self.heightSlider.value);
                            CGAffineTransform scale = CGAffineTransformMakeScale(self.heightSlider.value, self.heightSlider.value);
                            self.ballView.transform = scale;

                            
                        } completion:^(BOOL finished) {

                        }];*/
        
    } completion:^(BOOL finished) {
        
        [self changePlayerTurn];
        [self.startSwitch isOn] ? [self startAnimation]: nil;
        
    }];
}

- (void)startRotationWithDegree:(CGFloat) rotationDegree{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:rotationDegree];
    rotationAnimation.duration = self.animationDuration;
    [self.ballView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void) movePlayer:(UIImageView*)player toPoint:(CGPoint)destination withDuration:(CGFloat)duration andDelay:(CGFloat)delay options:(NSInteger)optionsMask{
    
    [UIView animateWithDuration:duration delay:delay options:optionsMask animations:^{
        
        player.center = destination;
        
    } completion:^(BOOL finished) {
    }];
}


- (void) animateView:(UIImageView *) view withImages:(NSArray*) images andDuration:(CGFloat) duration andRepeaCount:(NSInteger) count{
    
    view.animationDuration = duration;
    view.animationImages = images;
    view.animationRepeatCount = count;
    [view startAnimating];
}



#pragma mark - Destination Points -

- (CGPoint) ballDestinationPointWithPlayerTurn:(UIImageView *) turn{
    
    //return CGPointMake([turn isEqual:self.player1]? CGRectGetMidX(self.player2.frame): CGRectGetMidX(self.player1.frame), (float)(arc4random()%190) +40);
    
    return CGPointMake([turn isEqual:self.playerOneView]?  (float)(arc4random()% (int)CGRectGetWidth(self.view.bounds)/3) + CGRectGetWidth(self.view.bounds)*3/5 :
                       
                       
                       (float)(arc4random()%(int)CGRectGetWidth(self.view.bounds)/4) + CGRectGetWidth(self.view.bounds)/16,
                       
                       (float)(arc4random()%(int)(CGRectGetHeight(self.view.bounds)/3)) +
                       CGRectGetHeight(self.view.bounds)/10);
    
}


- (CGPoint) player:(UIView *)player destinationPointWithPlayerTurn:(UIView *)turn andBallDestination:(CGPoint) ballDestination{
    
    if([turn isEqual:player] && [player isEqual:self.playerOneView]){
        return self.player1Home;
        
        
    }else if([turn isEqual:player] && [player isEqual:self.playerTwoView]){
        return self.player2Home;
    
    
    }else{
        return ballDestination;
    }
}


#pragma mark - Change Turn -

- (void) changePlayerTurn{
    self.playerTurn = [self.playerTurn isEqual:self.playerOneView] ? self.playerTwoView : self.playerOneView;
}

#pragma mark - Controls Actions

- (IBAction)ballTypeChangedAction:(UISegmentedControl *)sender {
    
    [self.ballView setImage:[self.balls objectAtIndex:[sender selectedSegmentIndex]]];
    
}

- (IBAction)startAction:(UISwitch *)sender {
    
    if ([sender isOn]) {
        
        [self startAnimation];
    
    }else{
        [self.view.layer removeAllAnimations];
        [self.ballView.layer removeAllAnimations];
        [self.playerOneView.layer removeAllAnimations];
        [self.playerTwoView.layer removeAllAnimations];

    }
    
}

- (IBAction)powerSliderValueChanged:(UISlider *)sender {
    
    self.animationDuration = sender.value;
}

- (IBAction)heightSliderValueChanged:(UISlider *)sender {
    
    self.animationScale = sender.value;
}
@end
