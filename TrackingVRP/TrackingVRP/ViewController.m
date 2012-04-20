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

@synthesize dictFromFile;
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
    NSLog(@" objet %@ \n",path);
    self.dictFromFile = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    
    // creation du brain avec le Plist
    brain = [[TrackingBrain alloc] initWithDictionaryFromPlist:dictFromFile];
    brain.brainDelegate = self;

        
    
    CLLocation *location = [self.brain getLocation];
        
        
        
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.heureActuelleString]];
    NSLog(@"heure actuel: %@",self.brain.heureActuelleString);
    [button setEnabled:NO];
   
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{

    [dictFromFile release];
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
    



    
     
    graph = [[[GraphViewController alloc] initWithData:self.brain.h24] autorelease];
    

   
    [graph dessinerGraph];
    
    [self.navigationController pushViewController:graph animated:YES];

}


- (IBAction)locateMe:(UIButton*)sender{
    CLLocation *location = [self.brain getLocation];
    NSLog(@"%f", [[location timestamp] timeIntervalSinceNow] );

    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", self.brain.distanceTotal]];
    [distancePartiel setText: [NSString stringWithFormat:@"distance du tour: %f", self.brain.distanceDutour]];
    [heureActuel setText: [NSString stringWithFormat:@"heure: %@", self.brain.heureActuelleString]];
    NSString *resourceDirectory = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resourceDirectory stringByAppendingPathComponent:@"properties.plist"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
    [self.dictFromFile setObject:@"salutt" forKey:@"heureActuelle"];
    for (int i =0; i < [dictFromFile count]; i++) {
        NSLog(@" sauvegarde %@ \n", [[dictFromFile allValues] objectAtIndex:i]);
    }
    if([dictFromFile writeToFile:path atomically:YES]){
        NSLog(@"OK");
    }
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

-(void)update:(double) distance for:(TrackingBrain *) requestor{

    NSLog(@"delegate!!!!!");
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %f", distance]];


}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
