//
//  ViewController.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingView.h"
#import "TrackingBrain.h"

@interface ViewController : UIViewController <TrackingViewDelegate>{

IBOutlet UILabel *display;
TrackingBrain *brain;
}

@property(nonatomic,retain) UILabel *display;
@property(nonatomic,retain) TrackingBrain *brain;

-(IBAction)locateMe:(id)sender;

@end
