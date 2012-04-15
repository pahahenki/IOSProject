//
//  ViewController.m
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import <CoreLocation/CLLocationManager.h>



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

        
    
    CLLocation *location = [self.brain getLocation];
        
        
        
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.donnee.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.donnee.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.donnee.heureActuelleString]];
    NSLog(@"heure actuel: %@",self.brain.donnee.heureActuelleString);
    [button setEnabled:NO];
   
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

- (IBAction)Graph:(id)sender{
    



    
     
    GraphViewController *gcal = [[[GraphViewController alloc] init] autorelease];
    
    
    [self.navigationController pushViewController:gcal animated:YES];

}


- (IBAction)locateMe:(UIButton*)sender{
    CLLocation *location = [self.brain getLocation];
    NSLog(@"%f", [[location timestamp] timeIntervalSinceNow] );

    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.donnee.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.donnee.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.donnee.heureActuelleString]];
}

- (IBAction)startMe:(UIButton*)sender{
    
    NSLog(@"%s", [CLLocationManager locationServicesEnabled]? "true" : "false");
    if ([CLLocationManager locationServicesEnabled]== YES) {
        [self.brain demarrer];
        [button setEnabled:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"service localisation" message:@"Localisation impossible, merci d'activer votre service de localisation "delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

-(IBAction)stopMe:(UIButton *)sender{
        [self.brain arreter];
        [button setEnabled:NO];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
