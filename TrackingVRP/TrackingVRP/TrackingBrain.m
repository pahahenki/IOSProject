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
@synthesize heureActuelle,heureActuelleString,h24;
@synthesize locMgr;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.distanceTotal = 0;
        self.distanceParHeure = 0;
        h24 = [[NSMutableArray alloc] initWithCapacity:24];
        for(int i = 0; i < 24; i++){
            [h24 insertObject:[NSNumber numberWithDouble:0] atIndex:i];
        }
        heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
        NSLog(@"%@",heureActuelleString);
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
        self.locMgr.distanceFilter = 100;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [self.locMgr startUpdatingLocation];
    }
    return self;
}

-(void)dealloc{
    [h24 dealloc];
    [heureActuelle dealloc];
    [timeFormatter dealloc];
    [heureActuelleString dealloc];
    [locMgr dealloc];
    [super dealloc];
}

// changer, ne pas utiliser getlocation plustot new et old location en deux champ mis a jour aves la methode locationManeger de dessous

-(CLLocation *) getLocation{
    return self.locMgr.location;
}




- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.heureActuelle = [NSDate date];
    NSString *tmp = [timeFormatter stringFromDate:self.heureActuelle];
    //On regarde si l'heure a changé
    if(![tmp isEqualToString:self.heureActuelleString]){
        //On met la distance parcourue par heure dans notre tableau
        int index = [self.heureActuelleString intValue];
        [h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:self.distanceParHeure]];
        self.distanceParHeure = 0;
    }
    //On met à jour l'heure actuelle
    [self.heureActuelleString setString:tmp];
    self.distanceParHeure += (double) [oldLocation distanceFromLocation:newLocation];
    self.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
    //self.distanceDutour = (double) [oldLocation distanceFromLocation:newLocation];
    NSLog(@"%f, %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
}



@end
