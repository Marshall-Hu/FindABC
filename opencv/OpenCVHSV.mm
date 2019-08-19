//
//  OpenCVHSV.m
//  FindABC
//
//  Created by StarSky_MacBook Pro on 2019/7/31.
//  Copyright © 2019 StarSky_MacBook Pro. All rights reserved.
//

#import "OpenCVHSV.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>


using namespace cv;
using namespace std;


@interface OpenCVHSV()<CvVideoCameraDelegate>
{
    int outputSize;
}
@property (nonatomic,strong) CvVideoCamera* videoCamera;

@end

//定义变量
vector<vector<cv::Point>> contours;
vector<Vec4i> hierarchy;

vector<vector<cv::Point>> fakeContours;

Mat temp_element_1;
Mat temp_imgThresholded;
Mat imgThresholded_Mix;

Mat imgThresholded_red;
Mat imgThresholded_blue;
Mat imgThresholded_green;

@implementation OpenCVHSV
- (void)isThisWorking{
    
    cout << "Hey" << endl;
    
}

-(void) initHSV
{
    outputSize = 300;
    iLowS = 40;
    iHighS = 255;
    iLowV = 1;
    iHighV = 255;
    //Blue 789
    iLowH = 115;
    iHighH = 130;
    
    temp_element_1 = getStructuringElement(MORPH_RECT, cv::Size(30, 30));
    //Red 0213
    iLowH_red = 170;
    iHighH_red = 179;
    
    //Green 456
    iLowH_green = 30;
    iHighH_green = 58;
    
    self.videoCamera = [[CvVideoCamera alloc] init];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition =AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset =AVCaptureSessionPresetHigh;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 5;
    
    //[self.view addSubview:self.videoCameraView];
     [self.videoCamera start];
    NSLog(@"w初始化相机侦测");
}

- (void)processImage:(cv::Mat &)image
{
    // 将图像转换为灰度显示
    //cvtColor(image, image, COLOR_RGBA2RGB);
    Mat imgHSV;
    vector<Mat> hsvSplit;
    cvtColor(image, imgHSV, COLOR_BGR2HSV); //Convert the captured frame from BGR to HSV
    
    //因为我们读取的是彩色图，直方图均衡化需要在HSV空间做
    split(imgHSV, hsvSplit);
    equalizeHist(hsvSplit[2],hsvSplit[2]);
    merge(hsvSplit,imgHSV);

    inRange(imgHSV, Scalar(iLowH, iLowS, iLowV), Scalar(iHighH, iHighS, iHighV), imgThresholded_blue);
    inRange(imgHSV, Scalar(iLowH_red, iLowS, iLowV), Scalar(iHighH_red, iHighS, iHighV), imgThresholded_red);
    inRange(imgHSV, Scalar(iLowH_green, iLowS, iLowV), Scalar(iHighH_green, iHighS, iHighV), imgThresholded_green);
    //开操作 (去除一些噪点)//闭操作 (连接一些连通域)
    Mat element = getStructuringElement(MORPH_RECT, cv::Size(5, 5));
    //morphologyEx(imgThresholded_red, imgThresholded_red, MORPH_OPEN, element);
    morphologyEx(imgThresholded_red, imgThresholded_red, MORPH_CLOSE, element);
    //morphologyEx(imgThresholded_blue, imgThresholded_blue, MORPH_OPEN, element);
    morphologyEx(imgThresholded_blue, imgThresholded_blue, MORPH_CLOSE, element);
    //morphologyEx(imgThresholded_green, imgThresholded_green, MORPH_OPEN, element);
    morphologyEx(imgThresholded_green, imgThresholded_green, MORPH_CLOSE, element);
    
    if (!imgThresholded_blue.empty()) {
        
        imgThresholded_blue.copyTo(temp_imgThresholded);
        morphologyEx(temp_imgThresholded, temp_imgThresholded, MORPH_CLOSE, temp_element_1);
        findContours(temp_imgThresholded, contours, hierarchy, RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
        CvRect rect;
        //fakeContours = MatGetAreaMaxContour(contours);
        fakeContours = MatGetQualifiedAreaContour(contours);

        NSMutableArray* RectImageArray = [[NSMutableArray alloc] init];
        
        if (!contours.empty() && !fakeContours.empty()) {
            //cout<<"蓝色:"<<fakeContours.size()<<endl;
            
            for (int i = 0; i < fakeContours.size(); i++) {
                rect = boundingRect(fakeContours[i]);
                Mat ROI = imgThresholded_blue(rect);
                // NSLog(@"1111111111111111:%d,%d",ROI.cols,ROI.rows);
                Mat temp;
                Mat zero = Mat::zeros(outputSize, outputSize, temp.type());
                
                if ((float) ROI.cols / outputSize > (float) ROI.rows / outputSize) {
                    resize(ROI, temp, cv::Size(outputSize, ROI.rows * outputSize / (float) ROI.cols));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i+(outputSize/2 - temp.rows /2), j) = temp.at<uchar>(i, j);
                        }
                    }
                }
                else if ((float) ROI.cols / outputSize < (float) ROI.rows / outputSize)
                {
                    resize(ROI, temp, cv::Size(ROI.cols * outputSize / (float) ROI.rows,outputSize));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i, j+(outputSize/2 - temp.cols /2)) = temp.at<uchar>(i, j);
                        }
                    }
                }
                [RectImageArray addObject:MatToUIImage(zero)];
            }
        }
        [_delegate rectImageDidProcessedBlue:RectImageArray];
    }
    if(!contours.empty())
    contours.clear();//记录面积的作用
    
    if (!imgThresholded_red.empty()) {
//
//        imgThresholded_red.copyTo(temp_imgThresholded);
//        morphologyEx(temp_imgThresholded, temp_imgThresholded, MORPH_CLOSE, temp_element_1);
        findContours(imgThresholded_red, contours, hierarchy, RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
        CvRect rect;
        //fakeContours = MatGetAreaMaxContour(contours);
        fakeContours = MatGetQualifiedAreaContour(contours);
        
        NSMutableArray* RectImageArray = [[NSMutableArray alloc] init];
        
        if (!contours.empty() && !fakeContours.empty()) {
            //cout<<"红色:"<<fakeContours.size()<<endl;
            
            for (int i = 0; i < fakeContours.size(); i++) {
                rect = boundingRect(fakeContours[i]);
                Mat ROI = imgThresholded_red(rect);
                // NSLog(@"1111111111111111:%d,%d",ROI.cols,ROI.rows);
                Mat temp;
                Mat zero = Mat::zeros(outputSize, outputSize, temp.type());
                
                if ((float) ROI.cols / outputSize > (float) ROI.rows / outputSize) {
                    resize(ROI, temp, cv::Size(outputSize, ROI.rows * outputSize / (float) ROI.cols));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i+(outputSize/2 - temp.rows /2), j) = temp.at<uchar>(i, j);
                        }
                    }
                }
                else if ((float) ROI.cols / outputSize < (float) ROI.rows / outputSize)
                {
                    resize(ROI, temp, cv::Size(ROI.cols * outputSize / (float) ROI.rows,outputSize));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i, j+(outputSize/2 - temp.cols /2)) = temp.at<uchar>(i, j);
                        }
                    }
                }
                [RectImageArray addObject:MatToUIImage(zero)];
            }
        }
        [_delegate rectImageDidProcessedRed:RectImageArray];
    }
    if(!contours.empty())
        contours.clear();//记录面积的作用
    
    if (!imgThresholded_green.empty()) {
        
        imgThresholded_green.copyTo(temp_imgThresholded);
        morphologyEx(temp_imgThresholded, temp_imgThresholded, MORPH_CLOSE, temp_element_1);
        findContours(temp_imgThresholded, contours, hierarchy, RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
        CvRect rect;
        //fakeContours = MatGetAreaMaxContour(contours);
        fakeContours = MatGetQualifiedAreaContour(contours);
        
        NSMutableArray* RectImageArray = [[NSMutableArray alloc] init];
        
        if (!contours.empty() && !fakeContours.empty()) {
            //cout<<"绿色:"<<fakeContours.size()<<endl;
            
            for (int i = 0; i < fakeContours.size(); i++) {
                rect = boundingRect(fakeContours[i]);
                Mat ROI = imgThresholded_green(rect);
                // NSLog(@"1111111111111111:%d,%d",ROI.cols,ROI.rows);
                Mat temp;
                Mat zero = Mat::zeros(outputSize, outputSize, temp.type());
                
                if ((float) ROI.cols / outputSize > (float) ROI.rows / outputSize) {
                    resize(ROI, temp, cv::Size(outputSize, ROI.rows * outputSize / (float) ROI.cols));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i+(outputSize/2 - temp.rows /2), j) = temp.at<uchar>(i, j);
                        }
                    }
                }
                else if ((float) ROI.cols / outputSize < (float) ROI.rows / outputSize)
                {
                    resize(ROI, temp, cv::Size(ROI.cols * outputSize / (float) ROI.rows,outputSize));
                    for (int i = 0; i < temp.rows; i++)
                    {
                        for (int j = 0; j < temp.cols; j++)
                        {
                            zero.at<uchar>(i, j+(outputSize/2 - temp.cols /2)) = temp.at<uchar>(i, j);
                        }
                    }
                }
                [RectImageArray addObject:MatToUIImage(zero)];
            }
        }
        [_delegate rectImageDidProcessedGreen:RectImageArray];
    }
    
    if(!contours.empty())
        contours.clear();//记录面积的作用
    
    bitwise_or(imgThresholded_green, imgThresholded_red, imgThresholded_Mix);
    bitwise_or(imgThresholded_blue, imgThresholded_Mix, imgThresholded_Mix);

    if ([_delegate respondsToSelector:@selector(imageDidProcessed:)]) {
        [_delegate imageDidProcessed:MatToUIImage(imgThresholded_Mix)];
    }
}

vector<vector<cv::Point>> MatGetAreaMaxContour(vector<vector<cv::Point>> contour)
{//在给定的contour中找到面积最大的一个轮廓，并返回指向该轮廓的指针
    double contour_area_temp=0,contour_area_max=0;
    vector<vector<cv::Point>> area_max_contour ;//指向面积最大的轮廓
    
    for(int i = 0 ; i < contour.size();i++)
    {//寻找面积最大的轮廓，即循环结束时的area_max_contour
        contour_area_temp = fabs(contourArea(contour[i])); //获取当前轮廓面积
        if( contour_area_temp > 1500 &&  contour_area_temp > contour_area_max )
        {
            contour_area_max = contour_area_temp; //找到面积最大的轮廓
            //Max_c = contour[i];
            area_max_contour.push_back(contour[i]);//记录面积最大的轮廓
        }
    }
    
    return area_max_contour;
}

vector<vector<cv::Point>> MatGetQualifiedAreaContour(vector<vector<cv::Point>> contour)
{//在给定的contour中找到面积最大的一个轮廓，并返回指向该轮廓的指针

    vector<vector<cv::Point>> area_qualified_contour ;//指向面积最大的轮廓
    double contour_area_temp=0;
    for(int i = 0 ; i < contour.size();i++)
    {//寻找面积最大的轮廓，即循环结束时的area_max_contour
        contour_area_temp = fabs(contourArea(contour[i])); //获取当前轮廓面积
        
        //NSLog(@"d面积是:%f",contour_area_temp);
        
        if( contour_area_temp > 3000)
        {
            area_qualified_contour.push_back(contour[i]);//记录面积最大的轮廓
        }
    }
    
    return area_qualified_contour;
}

-(void) SetiLowH:(int) i{
    iLowH = i;
}
-(void) SetiHighH:(int) i{
    iHighH = i;
}
-(void) SetiLowS:(int) i{
    iLowS = i;
}
-(void) SetiHighS:(int) i{
    iHighS = i;
}
-(void) SetiLowV:(int) i{
    iLowV = i;
}
-(void) SetiHighV:(int) i{
    iHighV = i;
}


@end
