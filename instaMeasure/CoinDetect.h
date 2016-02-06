//
//  CoinDetect.h
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#ifndef CoinDetect_h
#define CoinDetect_h


#endif /* CoinDetect_h */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <opencv2/opencv.hpp>
#include <opencv2/imgproc/imgproc_c.h>

@interface CoinDetect : NSObject


+ (UIImage*) coinDetect:(UIImage*)image
                     dp:(double)dp
                minDist:(double)minDist
                 param1:(double)param1
                 param2:(double)param2
             min_radius:(int)min_radius
             max_radius:(int)max_radius
                 touchX:(float)touchX
                 touchY:(float)touchY
             shotHeight:(float)shotHeight
              shotWidth:(float)shotWidth
                  blank:(UIImage*)blank
           screenHeight:(float)screenHeight
            screenWidth:(float)screenWidth
               coinType:(int) coinType;

+ (UIImage*) coinDetect2:(UIImage*)image
                     dp:(double)dp
                minDist:(double)minDist
                 param1:(double)param1
                 param2:(double)param2
             min_radius:(int)min_radius
             max_radius:(int)max_radius
                 touchX:(float)touchX
                 touchY:(float)touchY
             shotHeight:(float)shotHeight
              shotWidth:(float)shotWidth
                  blank:(UIImage*)blank
           screenHeight:(float)screenHeight
            screenWidth:(float)screenWidth
               coinType:(int) coinType;

+ (UIImage*) coinStitch:(NSMutableArray*)images
                     dp:(double)dp
                minDist:(double)minDist
                 param1:(double)param1
                 param2:(double)param2
             min_radius:(int)min_radius
             max_radius:(int)max_radius
                 touchX:(float)touchX
                 touchY:(float)touchY
             shotHeight:(float)shotHeight
              shotWidth:(float)shotWidth
                  blank:(UIImage*)blank
           screenHeight:(float)screenHeight
            screenWidth:(float)screenWidth
               coinType:(int) coinType;


@end