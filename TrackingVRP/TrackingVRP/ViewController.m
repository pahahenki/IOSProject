//
//  ViewController.m
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

@synthesize longitude;
@synthesize latitude;
@synthesize distanceTotal;
@synthesize distancePartiel;
@synthesize heureActuel;
@synthesize brain;
@synthesize button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    brain = [[TrackingBrain alloc] init];

        
    [self.brain demarrer];
    CLLocation *location = [self.brain getLocation];
        
        
        
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.heureActuelleString]];
    NSLog(@"heure actuel: %@",self.brain.heureActuelleString);

   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [longitude release];
    [latitude release];
    [brain release];
    [button release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc{
    [longitude release];
    [latitude release];
    [brain release];
    [button release];
    [super dealloc];
}


- (IBAction)locateMe:(UIButton*)sender{
    CLLocation *location = [self.brain getLocation];

    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.heureActuelleString]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
