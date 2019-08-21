//
//  HSVModel.swift
//  FindABC
//
//  Created by StarSky_MacBook Pro on 2019/7/31.
//  Copyright © 2019 StarSky_MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class HSVModel: NSObject{
    public static let inputWidth = 224
    public static let inputHeight = 224
    
    let model_hsv = number_250_224()
    let modelHSV_Red = HSV_Red()
    let modelHSV_Blue = HSV_Blue()
    let modelHSV_Green = HSV_Green()
    
    @objc public func MyHSVModel(image:UIImage) -> NSInteger
    {
        print("MyHSVModel开始执行")
        let result = try? predict_v1(image: image.pixelBuffer(width: HSVModel.inputWidth, height: HSVModel.inputHeight)!)
        
        if result != nil  {
            
           // print(result!.max()!)
            var max = result![0],index = 0
            for i in 0..<result!.count{
                if result![i] > max{
                    max = result![i]
                    index = i
                }
            }
            print("得到的数字是",index)
            
            return index
        }
        else
        {
            print("分析失败");
            return -1
        }
    }
    
    @objc public func MyHSVModel_Red(image:UIImage) -> NSInteger
    {
        print("red 分析")
        let result = try? predict_v1_red(image: image.pixelBuffer(width: HSVModel.inputWidth, height: HSVModel.inputHeight)!)
        
        if result != nil  {
            
            // print(result!.max()!)
            var max = result![0],index = 0
            for i in 0..<result!.count{
                if result![i] > max{
                    max = result![i]
                    index = i
                }
            }
            print("得到的数字是",index)
            
            return index
        }
        else
        {
            print("分析失败");
            return -1
        }
    }
    
    @objc public func MyHSVModel_Blue(image:UIImage) -> NSInteger
    {
        print("blue 分析")
        let result = try? predict_v1_blue(image: image.pixelBuffer(width: HSVModel.inputWidth, height: HSVModel.inputHeight)!)
        
        if result != nil  {
            
            // print(result!.max()!)
            var max = result![0],index = 0
            for i in 0..<result!.count{
                if result![i] > max{
                    max = result![i]
                    index = i
                }
            }
            print("得到的数字是",index+7)
            
            return index + 7
        }
        else
        {
            print("分析失败");
            return -1
        }
    }
    
    @objc public func MyHSVModel_Green(image:UIImage) -> NSInteger
    {
        print("green 分析")
        let result = try? predict_v1_green(image: image.pixelBuffer(width: HSVModel.inputWidth, height: HSVModel.inputHeight)!)
        
        if result != nil  {
            
            // print(result!.max()!)
            var max = result![0],index = 0
            for i in 0..<result!.count{
                if result![i] > max{
                    max = result![i]
                    index = i
                }
            }
            print("得到的数字是",index+4)
            
            return index + 4
        }
        else
        {
            print("分析失败");
            return -1
        }
    }

    public func predict_v1(image: CVPixelBuffer) throws -> Array<Double> {
        
        print("开始分析图片");
        
        if let output = try? model_hsv.prediction(images__0: image) {
            return output2BoxOrigin(output.OutPut__0)
        } else {
            return [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        }
    }
    
    public func predict_v1_red(image: CVPixelBuffer) throws -> Array<Double> {
        
        print("开始分析图片");
        
        if let output = try? modelHSV_Red.prediction(images__0: image) {
            return output2BoxOrigin(output.OutPut__0)
        } else {
            return [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        }
    }
    
    public func predict_v1_blue(image: CVPixelBuffer) throws -> Array<Double> {
        
        print("开始分析图片");
        
        if let output = try? modelHSV_Blue.prediction(images__0: image) {
            return output2BoxOrigin(output.OutPut__0)
        } else {
            return [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        }
    }
    
    public func predict_v1_green(image: CVPixelBuffer) throws -> Array<Double> {
        
        print("开始分析图片");
        
        if let output = try? modelHSV_Green.prediction(images__0: image) {
            return output2BoxOrigin(output.OutPut__0)
        } else {
            return [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        }
    }
    
    func output2BoxOrigin(_ output: MLMultiArray) -> Array<Double> {
        var Values = Array<Double>()
        var counter = 0

        for _ in 0..<output.count {
            Values.append(Double(truncating: output[counter]))
            counter += 1
        }
        print("分析完毕");
        return Values
    }
}
