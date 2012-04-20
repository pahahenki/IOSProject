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





@implementation ViewController


@synthesize longitude;
@synthesize latitude;
@synthesize distanceTotal;
@synthesize distancePartiel;
@synthesize heureActuel;
@synthesize brain;
@synthesize button;
@synthesize graph;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Charger le fichier .plist dans un tableau que l'on appelera  dictFromFileFinal
    
    NSMutableDictionary *dictFromFile = [self load];
    
    // creation du brain avec le Plist
    if (!dictFromFile) {
        dictFromFile = [[NSMutableDictionary alloc] init ];
        self.brain = [[TrackingBrain alloc] init];
    }
    else {
        self.brain = [[TrackingBrain alloc] initWithDictionaryFromPlist:dictFromFile];

    }
    
    
    self.brain.brainDelegate = self;

        
    
    CLLocation *location = [self.brain getLocation];
        
        
        
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.distanceTotal]];


   
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
    
    [self save];
    
    graph = [[[GraphViewController alloc] initWithData:self.brain.h24] autorelease];
    
    [graph dessinerGraph];
    
    [self.navigationController pushViewController:graph animated:YES];

}


- (IBAction)save:(UIButton*)sender{
    
    [self save];
    

}

- (IBAction)load:(UIButton*)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];
    
    NSMutableDictionary *content = [[NSMutableDictionary alloc] initWithContentsOfFile:path ];
    [distancePartiel setText: [content objectForKey:@"salut"]];
    
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
    [self save];
    [self.brain arreter];
    [button setEnabled:NO];
    
}

-(void)update:(double) distance location: (CLLocation*) newLocation for:(TrackingBrain *) requestor{

    
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", distance]];
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", newLocation.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", newLocation.coordinate.latitude]];



}

- (NSMutableDictionary *)load{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];
    
    NSMutableDictionary *content = [[NSMutableDictionary alloc] initWithContentsOfFile:path ];
    
    return content;
}

- (void) save{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];

    [[self.brain getDicoForSave] writeToFile:path atomically:NO];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
