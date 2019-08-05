//
//  ViewController.m
//  FindABC
//
//  Created by StarSky_MacBook Pro on 2019/7/20.
//  Copyright © 2019 StarSky_MacBook Pro. All rights reserved.
//
#import "ViewController.h"
#import <FindABC-Swift.h>
#import "../opencv/OpenCVHSV.h"

@interface ViewController () <MyCreatHSVImageDelegate>
{
    OpenCVHSV *tempCV;
}
@property (weak, nonatomic) IBOutlet UIImageView *testView;
@property (strong, nonatomic) UIImageView *videoCameraView;
@property (weak, nonatomic) IBOutlet UIImageView *rectImage1;


@property (weak, nonatomic) IBOutlet UISlider *SliderH_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderH_high;
@property (weak, nonatomic) IBOutlet UISlider *SliderS_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderS_high;
@property (weak, nonatomic) IBOutlet UISlider *SliderV_low;
@property (weak, nonatomic) IBOutlet UISlider *SliderV_high;

@property (weak, nonatomic) IBOutlet UILabel *predictResult;


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
    
    UIImage *test = [UIImage imageNamed:@"WechatIMG708.jpeg"];
    NSLog(@"asdasdasdasd");
    HSVModel* tempModel =[ [HSVModel alloc] init];
    [tempModel MyHSVModelWithImage:test];
    NSLog(@"asdasdasdasd");
    
    tempCV = [OpenCVHSV new];
    tempCV.delegate = self;
    [tempCV isThisWorking];
    [tempCV initHSV];

}
- (IBAction)predictHandly:(id)sender {
    NSLog(@"predictHandly开始");
    HSVModel* tempModel =[ [HSVModel alloc] init];
//    NSLog(@"%ld", (long)[tempModel MyHSVModelWithImage:_rectImage1.image]);
    _predictResult.text = [NSString stringWithFormat:@"%ld",(long)[tempModel MyHSVModelWithImage:_rectImage1.image]];
    UIImageWriteToSavedPhotosAlbum(_rectImage1.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSLog(@"predictHandly结束");
}

-(void)sliderValueChanged_HL:(UISlider *)slider
{
    [tempCV SetiLowH:slider.value];
   // NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_HH:(UISlider *)slider
{
    // iHighH =slider.value;
    [tempCV SetiHighH:slider.value];
   // NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_SL:(UISlider *)slider
{
    // iLowS = slider.value;
    [tempCV SetiLowS:slider.value];
   // NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_SH:(UISlider *)slider
{
    // iHighS = slider.value;
    [tempCV SetiHighS:slider.value];
   // NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_VL:(UISlider *)slider
{
    // iLowV = slider.value;
    [tempCV SetiLowV:slider.value];
   // NSLog(@"slider value%f",slider.value);
}
-(void)sliderValueChanged_VH:(UISlider *)slider
{
    // iHighV = slider.value;
    [tempCV SetiHighV:slider.value];
   // NSLog(@"slider value%f",slider.value);
}

- (void)imageDidProcessed:(UIImage*)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_testView.image = image;
    });
    
}

-(void)rectImageDidProcessed:(NSArray *)rectImageArray{
    if (rectImageArray.count == 1) {
        UIImage* rectImage =(UIImage*) [rectImageArray objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_rectImage1.image = rectImage;
        });
    }
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

@end
