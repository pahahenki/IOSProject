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


@synthesize heureActuelle;
@synthesize locMgr;
@synthesize delegate;
@synthesize donnee;

- (id)init
{
    self = [super init];
    if (self) {
        
        
        //self.donnee = [[Sauvegarde alloc] init ];
        self.donnee = [NSKeyedUnarchiver unarchiveObjectWithFile:@"donnee.classe"];
        heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        self.donnee.heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;

        
    }
    return self;
}

-(void)dealloc{
    [NSKeyedArchiver archiveRootObject:donnee toFile:@"donnee.classe"];
    [donnee dealloc];
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
    if(![tmp isEqualToString:self.donnee.heureActuelleString]){
        //On met la distance parcourue par heure dans notre tableau
        int index = [self.donnee.heureActuelleString intValue];
        [self.donnee.h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:self.donnee.distanceParHeure]];
        self.donnee.distanceParHeure = 0;
    }
    //On met à jour l'heure actuelle
    [self.donnee.heureActuelleString setString:tmp];
    // calcule des distance uniquement si l'ancienne n'est pas egal a nil
    if (oldLocation != nil) {
        self.donnee.distanceParHeure += (double) [oldLocation distanceFromLocation:newLocation];
        self.donnee.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
        self.donnee.distanceDutour = (double) [oldLocation distanceFromLocation:newLocation];
        NSLog(@"%f, %f, %s, temps: %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude, [CLLocationManager locationServicesEnabled]? "true" : "false", [[newLocation timestamp] timeIntervalSinceDate:[oldLocation timestamp]]);
    }
    [NSKeyedArchiver archiveRootObject:donnee toFile:@"donnee.classe"];

    
    
}



@end
