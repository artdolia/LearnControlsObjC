//
//  ADViewController.h
//  L26_controls
//
//  Created by A D on 1/25/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *fieldView;
@property (weak, nonatomic) IBOutlet UIImageView *playerOneView;
@property (weak, nonatomic) IBOutlet UIImageView *playerTwoView;
@property (weak, nonatomic) IBOutlet UIImageView *ballView;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;
@property (weak, nonatomic) IBOutlet UISlider *powerSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ballTypeControl;
@property (weak, nonatomic) IBOutlet UISwitch *startSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rotateSwitch;

- (IBAction)ballTypeChangedAction:(UISegmentedControl *)sender;
- (IBAction)startAction:(UISwitch *)sender;
- (IBAction)powerSliderValueChanged:(UISlider *)sender;
- (IBAction)heightSliderValueChanged:(UISlider *)sender;

@end
