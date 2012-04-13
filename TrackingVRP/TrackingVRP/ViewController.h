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
    
    IBOutlet UILabel *longitude;
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *distanceTotal;
    IBOutlet UILabel *distancePartiel;
    IBOutlet UILabel *heureActuel;
    IBOutlet UIButton *button;
    TrackingBrain *brain;
}

@property(nonatomic,retain) UILabel *longitude;
@property(nonatomic,retain) UILabel *latitude;
@property(nonatomic,retain) UILabel *distanceTotal;
@property(nonatomic,retain) UILabel *distancePartiel;
@property(nonatomic,retain) UILabel *heureActuel;
@property(nonatomic,retain) UIButton *button;
@property(nonatomic,retain) TrackingBrain *brain;

-(IBAction)locateMe:(UIButton*) sender;

@end
