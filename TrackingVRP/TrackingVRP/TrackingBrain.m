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

@synthesize distanceTotal,distanceParHeure, distanceJournaliere, distanceSession;
@synthesize heureActuelleString, jourActuelleString;
@synthesize h24, semaine, mois, annee ;
@synthesize heureActuelle, jourActuelle;
@synthesize locMgr;
@synthesize delegate;
@synthesize brainDelegate;


/**** Initialisation a zero ( premiere initialisation ) ********/

- (id)init
{
    self = [super init];
    if (self) {
        
        self.distanceSession=0;
        self.distanceTotal = 0;
        self.distanceParHeure = 0;
        self.distanceJournaliere = 0;
        self.h24 = [[NSMutableArray alloc] initWithCapacity:24];
        self.semaine = [[NSMutableArray alloc] initWithCapacity:7];
        self.mois = [[NSMutableArray alloc] initWithCapacity:12];
        for(int i = 0; i < 24; i++){
            [h24 insertObject:[NSNumber numberWithFloat:0] atIndex:i];
        }
        for(int i = 0; i < 7; i++){
            [semaine insertObject:[NSNumber numberWithFloat:0] atIndex:i];
        }
        self.heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH"];
        self.heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
        [timeFormatter setDateFormat:@"EEEE"];
        self.jourActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
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
        self.distanceSession=0;
        self.distanceTotal = [[dictionnary objectForKey: @"distanceTotal"] doubleValue];
        self.distanceJournaliere = [[dictionnary objectForKey: @"distanceJournaliere"] doubleValue];
        self.distanceParHeure = [[dictionnary objectForKey: @"distanceHeure"] doubleValue];
        
        self.h24 = [dictionnary objectForKey: @"h24"];
        self.semaine = [dictionnary objectForKey: @"semaine"];
        
        self.heureActuelle =  [NSDate date];
        timeFormatter = [[NSDateFormatter alloc] init];

        [timeFormatter setDateFormat:@"HH"];
        heureActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];
        
        [timeFormatter setDateFormat:@"EEEE"];
        jourActuelleString = [[NSMutableString alloc] initWithString:[timeFormatter stringFromDate:heureActuelle]];


        /* initialistaion du LocationManager */
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
    }
    return self;
    
}

-(void)dealloc{
    
    [h24 release];
    [heureActuelleString release];
    [jourActuelleString release];
    [heureActuelle release];
    [timeFormatter release];
    [locMgr release];
    [self.locMgr stopUpdatingLocation];
    [super dealloc];
}

-(void) reset{
     self.distanceSession=0;
    self.distanceTotal = 0;
    self.distanceParHeure = 0;
    self.distanceJournaliere = 0;
    for(int i = 0; i < 24; i++){
        [h24 insertObject:[NSNumber numberWithFloat:0] atIndex:i];
    }
    for(int i = 0; i < 7; i++){
        [semaine insertObject:[NSNumber numberWithFloat:0] atIndex:i];
    }
    
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
    self.distanceSession = 0;

}

- (NSString *) formatDistance: (double) distance{
    if (distance > 1000) {
        return [NSString stringWithFormat:@"%.0f Km", distance/1000];
    }
    else {
        return [NSString stringWithFormat:@"%.0f m", distance];
    }
    
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
    [dico setObject: [NSNumber numberWithFloat: self.distanceJournaliere]  forKey:@"distanceJournaliere"];
    [dico setObject: self.h24  forKey:@"h24"];
    [dico setObject: self.semaine  forKey:@"semaine"];
    [dico autorelease];
    return dico;
    
}

-(int) getIndex{
    int indexJour =0;
    heureActuelle = [NSDate date];
    NSString *tmpJour = [timeFormatter stringFromDate:self.heureActuelle];
    if ([tmpJour isEqualToString:@"Monday"] | [tmpJour isEqualToString:@"lundi"]) {
        indexJour= 0;
        
    }
    
    else {
        if ([tmpJour isEqualToString:@"Sunday"] | [tmpJour isEqualToString:@"dimanche"]) {
            indexJour= 6;
            
        }
        
        else {
            if ([tmpJour isEqualToString:@"Tuesday"] | [tmpJour isEqualToString:@"mardi"]) {
                indexJour= 1;
                
            }
            else {
                if ([tmpJour isEqualToString:@"Wednesday"] |[tmpJour isEqualToString:@"mercredi"]) {
                    indexJour= 2;
                    
                }
                else {
                    if ([tmpJour isEqualToString:@"Thursday"] | [tmpJour isEqualToString:@"jeudi"]) {
                        indexJour= 3;
                    }
                    else {
                        if ([tmpJour isEqualToString:@"Friday"] | [tmpJour isEqualToString:@"vendredi"]) {
                            indexJour= 4;
                        }
                        else {
                            if ([tmpJour isEqualToString:@"Saturday"] | [tmpJour isEqualToString:@"samedi"]) {
                                indexJour= 5;
                            }
                        }
                    }
                }
                
            }
        }
    }
    return indexJour;
}



/* redefinition de la methode appellée a chaque fois qu'un nouvelle localisation est trouvé */

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    //calcule de la date actuel
    heureActuelle = [NSDate date];
    [timeFormatter setDateFormat:@"HH"];
    NSString *tmpHeure = [timeFormatter stringFromDate:self.heureActuelle];
    [timeFormatter setDateFormat:@"EEEE"];
    NSString *tmpJour = [timeFormatter stringFromDate:self.heureActuelle];
    int index = [self.heureActuelleString intValue];
    int indexJour= self.getIndex;
    
    
    

    // calcule des distance uniquement si l'ancienne n'est pas egal a nil
    
    
    if (oldLocation != nil) {
        
        
        
                //On regarde si l'heure a changé
        if(![tmpHeure isEqualToString:self.heureActuelleString]){  // si elle a changé:
            //on reset la distance par heure
            [self.h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat: self.distanceParHeure]];
            self.distanceParHeure = 0;
        }
        
        if(![tmpJour isEqualToString:self.jourActuelleString]){ // si le jour a changer
            

            [self.semaine replaceObjectAtIndex:indexJour withObject:[NSNumber numberWithFloat: self.distanceJournaliere]];
            self.distanceJournaliere = 0;
            

        }
            
        
        
        
        //On met à jour l'heure actuelle
        [self.heureActuelleString setString:tmpHeure];
        //met a jour l'index
        index= [self.heureActuelleString intValue];
        
        //On calcule la distance parcouru dupuis la derniere MAJ
        self.distanceParHeure += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceJournaliere += (double) [oldLocation distanceFromLocation:newLocation];
        self.distanceSession += (double) [oldLocation distanceFromLocation:newLocation];
        
        //On stock la distance par heure dans le tableai
        [self.h24 replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat: self.distanceParHeure]];
        
        //On stock la distance par jour dans le tableai
       // NSLog(@"index %d, dist sem : %f", indexJour, distanceJournaliere);
        [self.semaine replaceObjectAtIndex:indexJour withObject:[NSNumber numberWithFloat: self.distanceJournaliere]];
        
        //On envoi les info a sont delegate pour que l'interface graphique soit actualisée

        [brainDelegate update:[self formatDistance:self.distanceTotal] location:newLocation speed:newLocation.speed distanceJournaliere: [self formatDistance:self.distanceJournaliere] distanceSession: [self formatDistance:self.distanceSession] for:self];
        
    }
    
    
    
}



@end
