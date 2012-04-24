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

-(void) update:(NSString *) distance location: (CLLocation *)newLocation speed: (CLLocationSpeed)speed distanceJournaliere: (NSString *) distancesJournaliere distanceSession: (NSString *) distancesSession for: (TrackingBrain *)requestor;

@end


@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    
    //delegate du Brain
    id <TrackingBrainDelegate> brainDelegate;
    //delegate du CLLocationManager
    id delegate;

    NSDateFormatter *timeFormatter;

    
    
}

@property (nonatomic, assign) id <TrackingBrainDelegate> brainDelegate;
@property (nonatomic) double distanceTotal;
@property (nonatomic) double distanceParHeure;
@property (nonatomic) double distanceJournaliere;
@property (nonatomic) double distanceSession;
@property (nonatomic, retain) NSMutableString *heureActuelleString;
@property (nonatomic, retain) NSMutableString *jourActuelleString;
@property (nonatomic, retain) NSMutableArray *h24;
@property (nonatomic, retain) NSMutableArray *semaine;
@property (nonatomic, retain) NSMutableArray *mois;
@property (nonatomic, retain) NSMutableArray *annee;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, retain) NSDate *heureActuelle;
@property (nonatomic, retain) NSDate *jourActuelle;




/**** Initialisation a partir de donnée rangée dans un dictionnaire (ici recuperé dans un fichier  .plist) ****/
- (id) initWithDictionaryFromPlist: (NSDictionary *) dictionnary;
/*   */
- (void) reset;
- (NSString *) formatDistance: (double) distance;

/* Methode qui retourn la Localisation actuel */
-(CLLocation *) getLocation;
/* Methode qui demarre l'actualisation en boucle de la localisation */
-(void) demarrer;
/* methode qui stop l'actualisation en boucle de la position */
-(void) arreter;
/* methode qui regroupe toute les données dans un dictionnaire ( ici utilisait pour sauvegarder les données*/
-(NSMutableDictionary *) getDicoForSave;

@end
