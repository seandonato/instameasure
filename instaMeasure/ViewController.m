//
//  ViewController.m
//  CamRuler
//
//  Created by Sean Donato on 11/23/15.
//  Copyright © 2015 Sean Donato. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CamHeader.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextView *text;
@property (nonatomic, weak) IBOutlet UITextView *instruct;

@property (nonatomic, weak) IBOutlet UIButton *textB;
@property (nonatomic, weak) IBOutlet UIButton *instructB;


@end
 

@implementation ViewController
AppDelegate *appDelegate;


NSNumber *coin1;

- (void) viewDidLoad{
    
    [super viewDidLoad];

    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
 //   NSNumber *coin = appDelegate.coinType;
}
- (IBAction)penny:(id)sender {
    
        //UIButton *button=(UIButton*)sender;
        
        if([sender tag]==0){
            
            coin1 = [NSNumber numberWithInt:0];
            appDelegate.coinType = coin1;
        }
    
        else if([sender tag]==1){
            
            coin1 = [NSNumber numberWithInt:1];
            appDelegate.coinType = coin1;

            
        }
        else if([sender tag]==2){
            
            coin1 = [NSNumber numberWithInt:2];
            appDelegate.coinType = coin1;
        }
        else if([sender tag]==3){
            
            coin1 = [NSNumber numberWithInt:3];
            appDelegate.coinType = coin1;
        }
        
    }


- (IBAction)about:(id)sender{

    if(_text.hidden == YES){
        _text.hidden = NO;
        _textB.userInteractionEnabled = YES;
     
    }else{
        _text.hidden = YES;
        _textB.userInteractionEnabled = NO;
    }
}

- (IBAction)instructions:(id)sender{
    
    if(_instruct.hidden == YES){
        _instruct.hidden = NO;
        _instructB.userInteractionEnabled = YES;
        
        
    }else{
        _instruct.hidden = YES;
        _instructB.userInteractionEnabled = NO;

    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
