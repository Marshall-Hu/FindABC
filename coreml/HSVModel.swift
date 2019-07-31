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

class HSV{
    public static let inputWidth = 448
    public static let inputHeight = 448
    
    let model_hsv = number_200()
    
    public init() { }
    
    public func MyHSVModel(image:UIImage)
    {
        let result = try? predict_v1(image: image.pixelBuffer(width: HSV.inputWidth, height: HSV.inputHeight)!)
        
        if result != nil  {
            print(result!)
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
