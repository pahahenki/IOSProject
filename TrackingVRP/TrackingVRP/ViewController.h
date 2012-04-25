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
    IBOutlet UILabel *distanceSession;
    IBOutlet UILabel *heureActuel;
    IBOutlet UILabel *vitesse;
    IBOutlet UILabel *distanceJournaliere;
    TrackingBrain *brain;
    GraphViewController *graph;
}
@property(nonatomic,retain) UILabel *longitude;
@property(nonatomic,retain) UILabel *latitude;
@property(nonatomic,retain) UILabel *distanceTotal;
@property(nonatomic,retain) UILabel *distanceSession;
@property(nonatomic,retain) UILabel *distanceJournaliere;
@property(nonatomic,retain) UILabel *vitesse;
@property(nonatomic,retain) UILabel *heureActuel;
@property(nonatomic,retain) TrackingBrain *brain;
@property(nonatomic, retain) GraphViewController *graph;




-(IBAction)startMe:(UIButton*) sender;
-(IBAction)stopMe:(UIButton*) sender;
- (IBAction)Graph:(id)sender;
-(IBAction)reset:(UIButton*) sender;
-(void)save;
-(NSMutableDictionary *)load;

@end
