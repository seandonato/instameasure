//
//  Tape.h
//  CamRuler
//
//  Created by Sean Donato on 12/8/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#ifndef Tape_h
#define Tape_h


#endif /* Tape_h */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Tape : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (UIImage *)imageByCropping:(UIImage *)
imageToCrop toRect:(CGRect)rect;

- (void)screenShotPasser:(UIImage *)shot;


- (UIImage *)convertImageToGrayScale:(UIImage *)image;

- (UIImage *)scaleImageToSize:(CGSize)screenSize  imageTo:(UIImage*)screenShotTo;

- (UIImage *)scaleBlankImageToSize:(CGSize)screenSize  imageTo:(UIImage*)screenShotTo;

-(void) takePics;

- (void) tapeTimer:(NSTimer*) timer;

- (void) tapeOff:(NSTimer*) timer;


@end