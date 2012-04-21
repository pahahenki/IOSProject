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

@synthesize distanceTotal,distanceParHeure;
@synthesize heureActuelleString;
@synthesize h24;
@synthesize heureActuelle;
@synthesize locMgr;
@synthesize delegate;
@synthesize brainDelegate;


/**** Initialisation a zero ( premiere initialisation ) ********/

- (id)init
{
    self = [super init];
    if (self) {
        
        
        self.distanceTotal = 0;
        self.distanceParHeure = 0;
        self.h24 = [[NSMutableArray alloc] initWithCapacity:24];
        for(int i = 0; i < 24; i++){
            [h24 insertObject:[NSNumber numberWithFloat:0] atIndex:i];
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

/**** Initialisation a partir de donnée rangée dans un dictionnaire (ici recuperé dans un fichier  .plist) ****/

- (id) initWithDictionaryFromPlist: (NSDictionary *) dictionnary{
   
    self = [super init];
    
    if (self) {

        /* les données brute */
        self.distanceTotal = [[dictionnary objectForKey: @"distanceTotal"] doubleValue];
        
        self.distanceParHeure = [[dictionnary objectForKey: @"distanceHeure"] doubleValue];
        
        self.h24 = [dictionnary objectForKey: @"h24"];
        
        self.heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        self.heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];

        /* initialistaion du LocationManager */
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

/* Methode qui demarre l'actualisation en boucle de la localisation */

-(void) demarrer{
    [self.locMgr startUpdatingLocation];
    
    /* filtre de distance */
    //self.locMgr.distanceFilter = 100;
    
    /* reglage de la precision */
    self.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
}

/* methode qui stop l'actualisation en boucle de la position */

-(void) arreter{
    [self.locMgr stopUpdatingLocation];

}

/* Methode qui retourn la Localisation actuel */

-(CLLocation *) getLocation{
    return self.locMgr.location;
}

/* methode qui regroupe toute les données dans un dictionnaire ( ici utilisait pour sauvegarder les données*/

-(NSMutableDictionary *) getDicoForSave{
    NSMutableDictionary *dico = [[NSMutableDictionary alloc] init ];
    
    
    [dico setObject: [NSNumber numberWithFloat: self.distanceTotal]  forKey:@"distanceTotal"];
    [dico setObject: [NSNumber numberWithFloat: self.distanceParHeure]  forKey:@"distanceHeure"];
    [dico setObject: self.h24  forKey:@"h24"];
    
    return dico;
    
}

/* redefinition de la methode appellée a chaque fois qu'un nouvelle localisation est trouvé */

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    //calcule de la date actuel
    heureActuelle = [NSDate date];
    NSString *tmp = [timeFormatter stringFromDate:self.heureActuelle];
    int index = [self.heureActuelleString intValue];
    

    // calcule des distance uniquement si l'ancienne n'est pas egal a nil
    
    
    if (oldLocation != nil) {
                //On regarde si l'heure a changé
        if(![tmp isEqualToString:self.heureActuelleString]){  // si elle a changé:
            //on reset la distance par heure
            self.distanceParHeure = 0;
        }
        
        //On met à jour l'heure actuelle
        [self.heureActuelleString setString:tmp];
        
        //On calcule la distance parcouru dupuis la derniere MAJ
        self.distanceParHeure += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
        
        //On stock la distance par heure dans le tableai
        [self.h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat: self.distanceParHeure]];
        
        //On envoi les info a sont delegate pour que l'interface graphique soit actualisée

        [brainDelegate update:self.distanceTotal location:newLocation for:self];
        
    }
    
    
    
}



@end
