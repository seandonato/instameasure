//
//  CamHeader.h
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#ifndef CamHeader_h
#define CamHeader_h


#endif /* CamHeader_h */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CamHeader : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (UIImage *)imageByCropping:(UIImage *)
imageToCrop toRect:(CGRect)rect;

- (void)screenShotPasser:(UIImage *)shot;


- (UIImage *)convertImageToGrayScale:(UIImage *)image;

- (UIImage *)scaleImageToSize:(CGSize)screenSize  imageTo:(UIImage*)screenShotTo;

- (UIImage *)scaleBlankImageToSize:(CGSize)screenSize  imageTo:(UIImage*)screenShotTo;

@end
