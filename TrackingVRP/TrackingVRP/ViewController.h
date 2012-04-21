//
//  ViewController.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingBrain.h"
#import "GraphViewController.h"

@interface ViewController : UIViewController <TrackingBrainDelegate>{
    
    IBOutlet UILabel *longitude;
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *distanceTotal;
    IBOutlet UILabel *distancePartiel;
    IBOutlet UILabel *heureActuel;
    IBOutlet UIButton *button;
    TrackingBrain *brain;
    GraphViewController *graph;
}
@property(nonatomic,retain) UILabel *longitude;
@property(nonatomic,retain) UILabel *latitude;
@property(nonatomic,retain) UILabel *distanceTotal;
@property(nonatomic,retain) UILabel *distancePartiel;
@property(nonatomic,retain) UILabel *heureActuel;
@property(nonatomic,retain) UIButton *button;
@property(nonatomic,retain) TrackingBrain *brain;
@property(nonatomic, retain) GraphViewController *graph;




-(IBAction)save:(UIButton*) sender;
-(IBAction)startMe:(UIButton*) sender;
-(IBAction)stopMe:(UIButton*) sender;
- (IBAction)Graph:(id)sender;
-(void)save;
-(NSMutableDictionary *)load;

@end
