//
//  AAPLPreviewView.h
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#ifndef AAPLPreviewView_h
#define AAPLPreviewView_h


#endif /* AAPLPreviewView_h */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;

@interface AAPLPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
