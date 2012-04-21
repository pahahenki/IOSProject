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

-(void) update:(double) distance location: (CLLocation *)newLocation  for: (TrackingBrain *)requestor;

@end


@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    
    //delegate du Brain
    id <TrackingBrainDelegate> brainDelegate;
    //delegate du CLLocationManager
    id delegate;
    
    CLLocationManager *locMgr;
    NSDate *heureActuelle;
    NSDateFormatter *timeFormatter;
    //le tableau des distances pour chaque heure de la journée (pour le graphe)
    NSMutableArray *h24;
    double distanceTotal;
    double distanceParHeure;
    NSMutableString *heureActuelleString;
    
    
}

@property (nonatomic, assign) id <TrackingBrainDelegate> brainDelegate;
@property (nonatomic) double distanceTotal;
@property (nonatomic) double distanceParHeure;
@property (nonatomic, retain) NSMutableString *heureActuelleString;
@property (nonatomic, retain) NSMutableArray *h24;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) NSDate *heureActuelle;



/**** Initialisation a partir de donnée rangée dans un dictionnaire (ici recuperé dans un fichier  .plist) ****/
- (id) initWithDictionaryFromPlist: (NSDictionary *) dictionnary;
/* Methode qui retourn la Localisation actuel */
-(CLLocation *) getLocation;
/* Methode qui demarre l'actualisation en boucle de la localisation */
-(void) demarrer;
/* methode qui stop l'actualisation en boucle de la position */
-(void) arreter;
/* methode qui regroupe toute les données dans un dictionnaire ( ici utilisait pour sauvegarder les données*/
-(NSMutableDictionary *) getDicoForSave;

@end
