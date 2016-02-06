//
//  ImageUtility.h
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#ifndef ImageUtility_h
#define ImageUtility_h


#endif /* ImageUtility_h */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <opencv2/highgui/cap_ios.h>
#include <opencv2/opencv.hpp>

@interface ImageUtility : NSObject

extern const cv::Scalar RED;
extern const cv::Scalar GREEN;
extern const cv::Scalar BLUE;
extern const cv::Scalar BLACK;
extern const cv::Scalar WHITE;
extern const cv::Scalar YELLOW;
extern const cv::Scalar LIGHT_GRAY;

+ (cv::Mat) cvMatFromUIImage: (UIImage *) image;
+ (cv::Mat) cvMatGrayFromUIImage: (UIImage *)image;

+ (UIImage *) UIImageFromCVMat: (cv::Mat)cvMat;

@end