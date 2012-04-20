//
//  TrakingBrain.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TrackingBrain;

@protocol TrackingBrainDelegate

-(void) update:(double) distance for: (TrackingBrain *)requestor;

@end


@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    
    id <TrackingBrainDelegate> brainDelegate;
    CLLocationManager *locMgr;
    NSDate *heureActuelle;
    NSDateFormatter *timeFormatter;
    //le tableau des distances pour chaque heure de la journée (pour le graphe)
    id delegate;
    NSMutableArray *h24;
    double distanceTotal;
    double distanceDutour;
    double distanceParHeure;
    NSMutableString *heureActuelleString;
    
    
}

@property (nonatomic, assign) id <TrackingBrainDelegate> brainDelegate;
@property (nonatomic) double distanceTotal;
@property (nonatomic) double distanceDutour;
@property (nonatomic) double distanceParHeure;
@property (nonatomic, retain) NSMutableString *heureActuelleString;
@property (nonatomic, retain) NSMutableArray *h24;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) NSDate *heureActuelle;





- (id) initWithDictionaryFromPlist: (NSDictionary *) dictionnary;
-(CLLocation *) getLocation;
-(void) demarrer;
-(void) arreter;


@end
