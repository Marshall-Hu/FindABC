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
    public static let inputWidth = 30
    public static let inputHeight = 30
    
    let model_hsv = number_50()
    
    @objc public func MyHSVModel(image:UIImage)
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
            print(index)
            
            
        }
        else
        {
            print("分析失败");
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
    
    func output2BoxOrigin(_ output: MLMultiArray) -> Array<Double> {
        var Values = Array<Double>()
        var counter = 0

        for _ in 0..<10 {
            Values.append(Double(truncating: output[counter]))
            counter += 1
        }
        print("分析完毕");
        return Values
    }
    
    
    
    
    
    
}
