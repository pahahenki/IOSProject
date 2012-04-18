//
//  TrakingBrain.m
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingBrain.h"
#import "ViewController.h"





@implementation TrackingBrain

@synthesize distanceTotal,distanceParHeure, distanceDutour;
@synthesize heureActuelleString;
@synthesize h24;
@synthesize heureActuelle;
@synthesize locMgr;
@synthesize delegate;


- (id)init
{
    self = [super init];
    if (self) {
        
        
        self.distanceTotal = 0;
        self.distanceDutour = 0;
        self.distanceParHeure = 0;
        self.h24 = [[NSMutableArray alloc] initWithCapacity:24];
        for(int i = 0; i < 24; i++){
            [h24 insertObject:[NSNumber numberWithDouble:0] atIndex:i];
        }
        self.heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        self.heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;

        
    }
    return self;
}

- (id) initWithDictionaryFromPlist: (NSDictionary *) dictionnary{
    self = [super init];
    if (self) {
        for (int i =0; i < [dictionnary count]; i++) {
            NSLog(@" objet %@ \n", [[dictionnary allValues] objectAtIndex:i]);
        }
        self.distanceTotal = [[dictionnary objectForKey: @"distanceTotal"] doubleValue];
        self.distanceParHeure = [[dictionnary objectForKey: @"distanceHeure"] doubleValue];
        //self.heureActuelleString = [dictionnary objectForKey: @"heureActuelle"];
                self.h24 = [dictionnary objectForKey: @"h24"];
        self.heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        self.heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];

        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
    }
    return self;
    
}

-(void)dealloc{

    [h24 dealloc];
    [heureActuelle dealloc];
    [timeFormatter dealloc];
    [locMgr dealloc];
    [self.locMgr stopUpdatingLocation];
    [super dealloc];
}

// changer, ne pas utiliser getlocation plustot new et old location en deux champ mis a jour aves la methode locationManeger de dessous

-(void) demarrer{
    [self.locMgr startUpdatingLocation];
    //self.locMgr.distanceFilter = 100;
    self.locMgr.desiredAccuracy = kCLLocationAccuracyHundredMeters;
}

-(void) arreter{
    [self.locMgr stopUpdatingLocation];

}

-(CLLocation *) getLocation{
    return self.locMgr.location;
}




- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    
    heureActuelle = [NSDate date];
    NSString *tmp = [timeFormatter stringFromDate:self.heureActuelle];
    
    
    
    //On regarde si l'heure a changé
    if(![tmp isEqualToString:self.heureActuelleString]){
        //On met la distance parcourue par heure dans notre tableau
        int index = [self.heureActuelleString intValue];
        [self.h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:self.distanceParHeure]];
        self.distanceParHeure = 0;
    }
    //On met à jour l'heure actuelle
    [self.heureActuelleString setString:tmp];
    // calcule des distance uniquement si l'ancienne n'est pas egal a nil
    if (oldLocation != nil) {
        self.distanceParHeure += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceDutour = (double) [oldLocation distanceFromLocation:newLocation];
        NSLog(@"%f, %f, %s, temps: %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude, [CLLocationManager locationServicesEnabled]? "true" : "false", [[newLocation timestamp] timeIntervalSinceDate:[oldLocation timestamp]]);
    }

    
    
}



@end
