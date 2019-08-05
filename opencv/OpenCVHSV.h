//
//  OpenCVHSV.h
//  FindABC
//
//  Created by StarSky_MacBook Pro on 2019/7/31.
//  Copyright © 2019 StarSky_MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 步骤1:声明一份协议(OC中的协议一般写在类中的.h文件)
// 这个协议只有一个方法
@protocol MyCreatHSVImageDelegate <NSObject>

// 标记了optional关键字,表示协议中这个方法是可选择性实现(也就是可以不实现)
@required
/**
 *  这个方法通知「被委托对象」,所有设备已经连接上了.
 *
 *  @param image 传递连接上的设备数量给被委托对象
 */
- (void)imageDidProcessed:(UIImage*)image;
- (void)rectImageDidProcessed:(NSArray*) rectImageArray;

@end

@interface OpenCVHSV : NSObject{
    @public
    int iLowH;
    int iHighH;
    
    int iLowS;
    int iHighS;
    
    int iLowV;
    int iHighV;
}

@property (strong,nonatomic) UIImage* resultImage;
@property (weak) id<MyCreatHSVImageDelegate> delegate;

-(void) initHSV;
- (void)isThisWorking;
-(void)SetiLowH:(int) i;
-(void)SetiHighH:(int) i;
-(void)SetiLowS:(int) i;
-(void)SetiHighS:(int) i;
-(void)SetiLowV:(int) i;
-(void)SetiHighV:(int) i;


@end

NS_ASSUME_NONNULL_END
