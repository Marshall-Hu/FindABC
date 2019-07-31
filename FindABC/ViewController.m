//
//  ViewController.m
//  FindABC
//
//  Created by StarSky_MacBook Pro on 2019/7/20.
//  Copyright © 2019 StarSky_MacBook Pro. All rights reserved.
//
#import "ViewController.h"
#import <FindABC-Swift.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *testView;
@property (strong, nonatomic) UIImageView *videoCameraView;


@property (weak, nonatomic) IBOutlet UISlider *SliderH_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderH_high;
@property (weak, nonatomic) IBOutlet UISlider *SliderS_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderS_high;
@property (weak, nonatomic) IBOutlet UISlider *SliderV_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderV_high;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.videoCameraView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [_SliderH_low addTarget:self action:@selector(sliderValueChanged_HL:) forControlEvents:UIControlEventValueChanged];
    [_SliderH_high addTarget:self action:@selector(sliderValueChanged_HH:) forControlEvents:UIControlEventValueChanged];
    [_SliderS_low addTarget:self action:@selector(sliderValueChanged_SL:) forControlEvents:UIControlEventValueChanged];
    [_SliderS_high addTarget:self action:@selector(sliderValueChanged_SH:) forControlEvents:UIControlEventValueChanged];
    [_SliderV_low addTarget:self action:@selector(sliderValueChanged_VL:) forControlEvents:UIControlEventValueChanged];
    [_SliderV_high addTarget:self action:@selector(sliderValueChanged_VH:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *test = [UIImage imageNamed:@"test.jpg"];
    NSLog(@"asdasdasdasd");
    HSVModel* tempModel =[ [HSVModel alloc] init];
    [tempModel MyHSVModelWithImage:test];
    NSLog(@"asdasdasdasd");

}

-(void)sliderValueChanged_HL:(UISlider *)slider
{
    // iLowH =slider.value;
    NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_HH:(UISlider *)slider
{
    // iHighH =slider.value;
    
    NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_SL:(UISlider *)slider
{
    // iLowS = slider.value;
    NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_SH:(UISlider *)slider
{
    // iHighS = slider.value;
    NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_VL:(UISlider *)slider
{
    // iLowV = slider.value;
    NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_VH:(UISlider *)slider
{
    // iHighV = slider.value;
    NSLog(@"slider value%f",slider.value);
}

@end
