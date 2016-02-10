//
//  CoinDetect.m
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoinDetect.h"
#import "ImageUtility.h"
#import <opencv2/core/core_c.h>
#import <opencv2/highgui/ios.h>
#import <math.h>
#import "AppDelegate.h"


@implementation CoinDetect

AppDelegate *appDelegateCD;



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
            screenWidth:(float) screenWidth
               coinType:(int) coinType

{
    
    UIImage* result = nil;
//  convert the photo the camera took to MAT
    cv::Mat matImage;
    UIImageToMat(image, matImage);

    cv::Mat blankImage =  [ImageUtility cvMatFromUIImage:blank];
    cv::Mat grayImage;
//  blank is in wrong orientation, this fixes it
    transpose(blankImage, blankImage);
    flip(blankImage, blankImage,1); //transpose+flip(1)=CW
    
//convert the Mat to gray scale because Hough Circles alg needs grayscale image
    cv::cvtColor(matImage, grayImage, cv::COLOR_BGR2GRAY);
    
    
// Reduce the noise so we avoid false circle detection
    
    cv::GaussianBlur(grayImage, grayImage, cv::Size(9,9), 2, 2);
    

    cv::vector<cv::Vec3f> circles;
    
    
    
    cv::HoughCircles(  grayImage      //InputArray
                     , circles  //OutputArray
                     , CV_HOUGH_GRADIENT  //int method
                     , dp              //double       dp=1   1 ... 20
                     , grayImage.rows/8         //double minDist=10 log 1...1000
                     , param1          //double  param1=100
                     , param2          //double  param2=30  10 ... 50
                     , min_radius      //int  minRadius=1   1 ... 500
                     , max_radius      //int  maxRadius=30  1 ... 500
                     );
    
    /*
     http://docs.opencv.org/trunk/modules/imgproc/doc/feature_detection.html?highlight=houghcircles#void
     
     C++: void HoughCircles(InputArray image, OutputArray circles, int method, double dp, double minDist, double param1=100, double param2=100, int minRadius=0, int maxRadius=0 )
     
     Parameters:
     image – 8-bit, single-channel, grayscale input image.
     circles – Output vector of found circles. Each vector is encoded as a 3-element floating-point vector   .
     circle_storage – In C function this is a memory storage that will contain the output sequence of found circles.
     method – Detection method to use. Currently, the only implemented method is CV_HOUGH_GRADIENT , which is basically 21HT , described in [Yuen90].
     dp – Inverse ratio of the accumulator resolution to the image resolution. For example, if dp=1 , the accumulator has the same resolution as the input image. If dp=2 , the accumulator has half as big width and height.
     minDist – Minimum distance between the centers of the detected circles. If the parameter is too small, multiple neighbor circles may be falsely detected in addition to a true one. If it is too large, some circles may be missed.
     param1 – First method-specific parameter. In case of CV_HOUGH_GRADIENT , it is the higher threshold of the two passed to the Canny() edge detector (the lower one is twice smaller).
     param2 – Second method-specific parameter. In case of CV_HOUGH_GRADIENT , it is the accumulator threshold for the circle centers at the detection stage. The smaller it is, the more false circles may be detected. Circles, corresponding to the larger accumulator values, will be returned first.
     minRadius – Minimum circle radius.
     maxRadius – Maximum circle radius.
     The function finds circles in a grayscale image using a modification of the Hough transform.
     */
    
    int touchedCircles[circles.size()];
    int j = 0;
    
    for( int i = 0; i < circles.size(); i++ )
    {
        
        cv::Vec3i c = circles[i];
        float distance;
        float dx, dy;
        
        dx = touchX - c[0] ;
        dy =  touchY - c[1]  ;
        
 // find distance between touch and center of circle
        
        distance = sqrt(dx*dx + dy*dy);
        
// if the distance is less than or equal to the radius, then the touch is within the circle
        
        if(distance <= c[2]){
            float inch;
            
//diameter of the coin in points on the photo
            
            float diamf = c[2] * 2;
            
//converting it to int then back to float
//cuts off the trailing decimal at hundredths place for easier computation
            
            int diami = diamf *100;
            float diam = diami/100;
            
            touchedCircles[j] = i;
            j++;
            
//cointype 0 is penny, sent from second view into appdelegate,
//retrieved from appdelegate
            
            
            if(coinType ==0){
                
//a penny is .75 of an inch, so dividing the diameter
//by 3 will give us the amount in points needed to
//add to it to get the size of an inch in points relative to the penny
                
                float coin = diam/3;
                inch = coin + diam;
                
//thickness of a penny is .0598 of an inch,
//so we must get that in hundredths of inches on the photo
//so we get a hundredth of an inch then multiply that by the thickness
//then chop off the trailing decimal by multiplying and converting to an int
//then back to float and dividing
                
                float thickness = inch/100;
                float thickness1 = thickness *.0598;
                int thickness2 = thickness1 * 100;
                thickness1 = thickness2/100;
                inch = inch - thickness1;
            }
            else if(coinType == 1){
            
                float coinSub = 1 - .835;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                float thickness = inch/100;
                float thickness1 = thickness *.076;
                int thickness2 = thickness1 * 100;
                thickness1 = thickness2/100;
                inch = inch - thickness1;
            }
            else if(coinType==2){
                
                float coinSub = 1 - .705;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                float thickness = inch/100;
                float thickness1 = thickness *.053;
                int thickness2 = thickness1 * 100;
                thickness1 = thickness2/100;
                inch = inch - thickness1;
            }
            else if(coinType==3){
                
                float coinSub = 1 - .955;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
//                float coinF = diam/divisor;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                float thickness = inch/100;
                float thickness1 = thickness *.069;
                int thickness2 = thickness1 * 100;
                thickness1 = thickness2/100;
                inch = inch - thickness1;
            }
            
            int inchNum = 1;
            int inches = shotHeight/inch;
            float i1 = inch+40;
            float i2 = inch+40;
            
            float iEighth = inch/8;
            float eighth = iEighth+40;
            
            cv::Point e11 = cv::Point(0,eighth - iEighth);
            cv::Point e22 = cv::Point(50,eighth - iEighth);
            cv::Scalar col = cvScalar(255,255,255);
            cv::line(blankImage, e11, e22, col,2, 8, 0);

            
            for(int j = 0; j <inches; j++){
                
                cv::Point pt1 = cv::Point(0,i1);
                cv::Point pt2 = cv::Point(50,i2);
                cv::Scalar col = cvScalar(255,255,255);
                cv::line(blankImage, pt1, pt2, col,2, 8, 0);
                
                for(int m = 1; m < 8; m++){
                
                    if(m%2 == 0){
                        cv::Point e1 = cv::Point(0,eighth);
                        cv::Point e2 = cv::Point(40,eighth);
                        cv::Scalar col = cvScalar(255,255,255);
                        cv::line(blankImage, e1, e2, col,1, 8, 0);
                    }else{
                        cv::Point e1 = cv::Point(0,eighth);
                        cv::Point e2 = cv::Point(30,eighth);
                        cv::Scalar col = cvScalar(255,255,255);
                        cv::line(blankImage, e1, e2, col,1, 8, 0);
                        
                    }
                    eighth += iEighth;
                    
                }
                eighth = i1 + iEighth;
                
                std::string s = std::to_string(inchNum);
                
                cv::putText(blankImage, s, cv::Point(60,i2), cv::FONT_HERSHEY_TRIPLEX,3, col);
                
                i1 += inch;
                i2 += inch;
                
                inchNum++;
                
            }
            
            float centimeterf = inch/2.54;
            float centimeter = roundf(centimeterf*100.0)/100.0;
//            float centimeter = centimeterint / 100;
            int centNum = 1;
            int centimeters = shotHeight/centimeter;
            float centLine = centimeter + 40;
            
            float mmf = centimeter/10;
//            int mmf2 = mmf * 10;
//            float mmf3 = mmf2;
//            float mmi = mmf3/10;
            float mmi = (ceil(mmf*100))/100;
            float mm = mmi;
            float mmLine = mm + 40;
            
            cv::Point cc1 = cv::Point(250,mmLine - mm);
            cv::Point cc2 = cv::Point(screenWidth,mmLine - mm);
            cv::Scalar colo = cvScalar(255,255,255);
            cv::line(blankImage, cc1, cc2, colo,2, 8, 0);
            

            
            for(int k = 0; k <centimeters; k++){
                
                cv::Point c1 = cv::Point(250,centLine);
                cv::Point c2 = cv::Point(screenWidth,centLine);
                cv::Scalar col = cvScalar(255,255,255);
                cv::line(blankImage, c1, c2, col,1, 8, 0);
                
                for(int l = 1; l < 10; l++){
                    
                    if(l == 5){
                        cv::Point mm1 = cv::Point(275,mmLine);
                        cv::Point mm2 = cv::Point(screenWidth,mmLine);
                        cv::Scalar col = cvScalar(255,255,255);
                        cv::line(blankImage, mm1, mm2, col,1, 8, 0);
                    }else{
                        cv::Point mm1 = cv::Point(300,mmLine);
                        cv::Point mm2 = cv::Point(screenWidth,mmLine);
                        cv::Scalar col = cvScalar(255,255,255);
                        cv::line(blankImage, mm1, mm2, col,1, 8, 0);
                        
                    }
                    mmLine += mm;
                    
                }
                mmLine = centLine + mm;
                
                std::string s = std::to_string(centNum);
                
                cv::putText(blankImage, s, cv::Point(240,centLine), cv::FONT_HERSHEY_TRIPLEX,1, col);
                
                centLine += centimeter;
                
                centNum++;
                
            }
            
            
            
            
            
            cv::circle(blankImage , cv::Point(c[0], c[1]), c[2], cvScalar(0,0,255), 3, CV_AA);
            
            //circle( cimg, Poi nt(c[0], c[1]), 2, Scalar(0,255,0), 3, CV_AA);
            break;
            
        }
    }
    //todo see if this gets transparent
    cv::cvtColor(grayImage, matImage, cv::COLOR_GRAY2RGBA);
    
    //    int rows = image.size.height;
    //    int cols = image.size.width;
    //
    //
    //    float pointHeight = screenHeight/touchY;
    //    float pointWidth = screenWidth/touchX;
    //
    //    float newTouchX = rows/pointHeight;
    //    float newTouchY = cols/pointWidth;
    
    
    
//        if(circles.size()>0){
//    
//        cv::Point pt1 = cv::Point(0,0);
//        cv::Point pt2 = cv::Point(touchX,touchY);
//        cv::Scalar col = cvScalar(255,0,255);
//        cv::line(blankImage, pt2, pt1, col,10, 8, 0);
//        
//            cv::Vec3i c = circles[0];
//
//        cv::circle(blankImage , cv::Point(c[0], c[1]), c[2], cvScalar(0,0,255), 3, CV_AA);
//
//            
////            cv::Point pt3 = cv::Point(screenWidth,0);
////            cv::Point pt4 = cv::Point(0,screenHeight);
////            cv::Scalar colo = cvScalar(255,0,255);
////            cv::line(matImage, pt3, pt4, colo,10, 8, 0);
//        
//        
//        }
    result = [ImageUtility UIImageFromCVMat:blankImage];
//    result = MatToUIImage(blankImage);
//    result = blank;
    
    return result;
}


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
            screenWidth:(float) screenWidth
               coinType:(int) coinType

{
    appDelegateCD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *circleFound;

    
    UIImage* result = nil;
    //    cv::Mat matImage = [ImageUtility cvMatFromUIImage:image];
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    
    cv::Mat blankImage =  [ImageUtility cvMatFromUIImage:blank];
    //    cv::Mat blankImage;
    //    UIImageToMat(blank, blankImage, true);
    cv::Mat grayImage;
    //    cv::cvtColor(blankImage, blankImage, cv::COLOR_BGR2RGBA);
    transpose(blankImage, blankImage);
    flip(blankImage, blankImage,1); //transpose+flip(1)=CW
    
    cv::cvtColor(matImage, grayImage, cv::COLOR_BGR2GRAY);
    
    //grayImage2 = [ImageUtility cvMatFromUIImage:grayImage];
    
    /// Reduce the noise so we avoid false circle detection
    
    cv::GaussianBlur(grayImage, grayImage, cv::Size(9,9), 2, 2);
    //
    //    int rows = image.size.height;
    //    int cols = image.size.width;
    //    int brows = blank.size.width;
    //    int bcols = blank.size.height;
    //
    //
    //    float pointHeight = screenHeight/touchY;
    //    float pointWidth = screenWidth/touchX;
    //
    //    float newTouchY = touchY/pointHeight;
    //    float newTouchX = touchX;
    //    float newTouchX = cols/pointHeight;
    //    float newTouchY = rows/pointWidth;
    //
    cv::vector<cv::Vec3f> circles;
    
    cv::HoughCircles(  grayImage      //InputArray
                     , circles  //OutputArray
                     , CV_HOUGH_GRADIENT  //int method
                     , dp              //double       dp=1   1 ... 20
                     , grayImage.rows/8         //double minDist=10 log 1...1000
                     , param1          //double  param1=100
                     , param2          //double  param2=30  10 ... 50
                     , min_radius      //int  minRadius=1   1 ... 500
                     , max_radius      //int  maxRadius=30  1 ... 500
                     );
    
    /*
     http://docs.opencv.org/trunk/modules/imgproc/doc/feature_detection.html?highlight=houghcircles#void
     
     C++: void HoughCircles(InputArray image, OutputArray circles, int method, double dp, double minDist, double param1=100, double param2=100, int minRadius=0, int maxRadius=0 )
     
     Parameters:
     image – 8-bit, single-channel, grayscale input image.
     circles – Output vector of found circles. Each vector is encoded as a 3-element floating-point vector   .
     circle_storage – In C function this is a memory storage that will contain the output sequence of found circles.
     method – Detection method to use. Currently, the only implemented method is CV_HOUGH_GRADIENT , which is basically 21HT , described in [Yuen90].
     dp – Inverse ratio of the accumulator resolution to the image resolution. For example, if dp=1 , the accumulator has the same resolution as the input image. If dp=2 , the accumulator has half as big width and height.
     minDist – Minimum distance between the centers of the detected circles. If the parameter is too small, multiple neighbor circles may be falsely detected in addition to a true one. If it is too large, some circles may be missed.
     param1 – First method-specific parameter. In case of CV_HOUGH_GRADIENT , it is the higher threshold of the two passed to the Canny() edge detector (the lower one is twice smaller).
     param2 – Second method-specific parameter. In case of CV_HOUGH_GRADIENT , it is the accumulator threshold for the circle centers at the detection stage. The smaller it is, the more false circles may be detected. Circles, corresponding to the larger accumulator values, will be returned first.
     minRadius – Minimum circle radius.
     maxRadius – Maximum circle radius.
     The function finds circles in a grayscale image using a modification of the Hough transform.
     */
    
    for( int i = 0; i < circles.size(); i++ )
    {
        cv::Vec3i c = circles[i];
        float distance;
        float dx, dy;
        
        dx = touchX - c[0] ;
        dy =  touchY - c[1]  ;
        
        distance = sqrt(dx*dx + dy*dy);
        
        if(distance <= c[2]){
        circleFound= [NSNumber numberWithInt:1];

        appDelegateCD.cfound = circleFound;

            
            float inch;
            float diamf = c[2] * 2;
            int diami = diamf *100;
            float diam = diami/100;
            
            if(coinType ==0){
                
                float coin = diam/3;
                inch = coin + diam;
                
            }
            else if(coinType == 1){
                
                float coinSub = 1 - .835;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                
            }
            else if(coinType==2){
                
                float coinSub = 1 - .705;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                
            }
            else if(coinType==3){
                
                float coinSub = 1 - .955;
                float divisor = 1/coinSub;
                int divisorF = divisor * 100;
                float divisorI = divisorF/100;
                float coinF = diam/divisorI;
                //                float coinF = diam/divisor;
                int coinI = coinF * 100;
                float coin = coinI/100;
                inch = coin + diam;
                
            }
            
            
            
            cv::circle(blankImage , cv::Point(c[0], c[1]), c[2], cvScalar(0,0,255), 3, CV_AA);
            
            //circle( cimg, Point(c[0], c[1]), 2, Scalar(0,255,0), 3, CV_AA);
            
        }
        else{
            circleFound= [NSNumber numberWithInt:0];
            
            appDelegateCD.cfound = circleFound;

        }
    }
    //todo see if this gets transparent
    result = [ImageUtility UIImageFromCVMat:blankImage];
    //    result = MatToUIImage(blankImage);
    //    result = blank;
    
    return result;
}
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
               coinType:(int) coinType
{
    UIImage* result = nil;

    int iCount = (int) images.count;
    cv::vector<cv::Mat> matImages;

    for (int i = 0; i<iCount; i++) {
        UIImageToMat(images[i], matImages[i]);
    }
    cv::Mat panoramic;
    //cv::Stitcher stitcher = cv::Stitcher::createDefault(true);
    //stitcher.stitch(matImages, panoramic);
    
    result = [ImageUtility UIImageFromCVMat:panoramic];
    
    return result;

}


@end