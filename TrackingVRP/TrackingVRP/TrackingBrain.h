//
//  TrakingBrain.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locMgr;
    NSDate *heureActuelle;
    NSDateFormatter *timeFormatter;
    NSMutableString *heureActuelleString;
    //le tableau des distances pour chaque heure de la journée (pour le graphe)
    NSMutableArray *h24;
    id delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic) double distanceTotal;
@property (nonatomic) double distanceParHeure;
@property (nonatomic, retain) NSDate *heureActuelle;
@property (nonatomic, retain) NSMutableString *heureActuelleString;
@property (nonatomic, retain) NSMutableArray *h24;




-(double) calcultDistanceIntermediaireFrom: (const CLLocation *) previousLocation to: (const CLLocation *) myLocation;

-(CLLocation *) getLocation;



@end
