//
//  TrakingBrain.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Sauvegarde.h"




@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locMgr;
    NSDate *heureActuelle;
    NSDateFormatter *timeFormatter;
    //le tableau des distances pour chaque heure de la journée (pour le graphe)
    id delegate;
    Sauvegarde *donnee;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) NSDate *heureActuelle;
@property (nonatomic, retain) Sauvegarde *donnee;





-(CLLocation *) getLocation;
-(void) demarrer;
-(void) arreter;


@end
