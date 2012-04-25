//
//  ViewController.m
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import <CoreLocation/CLLocationManager.h>





@implementation ViewController


@synthesize longitude;
@synthesize latitude;
@synthesize distanceTotal;
@synthesize distanceSession;
@synthesize distanceJournaliere;
@synthesize vitesse;
@synthesize heureActuel;
@synthesize brain;
@synthesize graph;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Récupère le dictionnaire de donnée charger depuis un fichier
    
    NSMutableDictionary *dictFromFile = [self load];
    
    // creation du brain
    
    if (!dictFromFile) { //si on a rien recupèré du fichier (par exemple parce qu'il n'existe pas)
        
        // On initialise a zero
        brain = [[TrackingBrain alloc] init];
    }
    
    else { // sinon si on a recupéré qqch 
        
        // on initialise avec le dictionnaire recuperé
        brain = [[TrackingBrain alloc] initWithDictionaryFromPlist:dictFromFile];

    }
    
    // on initialise le delegate du brain
    self.brain.brainDelegate = self;

        
    // On récupere LA Localisation
    CLLocation *location = [self.brain getLocation];
        
        
    //On met a jour l'interface graphique
        
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", location.coordinate.longitude]];
    [latitude setText: [NSString stringWithFormat:@"latitude: %f", location.coordinate.latitude]];
    [distanceTotal setText: [NSString stringWithFormat:@"distance: %@", [self.brain formatDistance:self.brain.distanceTotal]]];
    [distanceJournaliere setText: [NSString stringWithFormat:@"distance Journaliere: %@", [self.brain formatDistance:self.brain.distanceJournaliere]]];
    [distanceSession setText: [NSString stringWithFormat:@"distance Session: %@", [self.brain formatDistance:self.brain.distanceSession]]];
    
     

   
}

- (void)viewDidUnload
{
    
    [longitude release];
    [latitude release];
    [brain release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)dealloc{

    [longitude release];
    [latitude release];
    [brain release];
    [super dealloc];
}


/* Action effectuer quand on presse le boutton graphe: affiche une nouvelle vue aec le(s) graphe */
- (IBAction)Graph:(id)sender{
    
    // On sauvegarde les données ( on sait jamais XD)
    [self save];
    
    // On initialise le controller de la vue du graphe avec les données de la journée en cours
    graph = [[[GraphViewController alloc] initWithData:self.brain.h24 semaine:self.brain.semaine] autorelease];
    
    // On dessine le graphe
    [graph dessinerGraph];
    
    // On pousse la vue
    [self.navigationController pushViewController:graph animated:YES];

}


/* Action qui permet de demarré l'update en boucle de la localisation */
/*      Relié au boutton start                                         */
- (IBAction)startMe:(UIButton*)sender{
    

    // On test si l'utilisateur autorise la localisation
    if ([CLLocationManager locationServicesEnabled]== YES) { // si oui 
        
        // on demarre l'updating
        [self.brain demarrer];

    }
    
    else{ // si non
        
        // On avertis l'utilisateur qu'il doit autoriser la localisation
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"service localisation" message:@"Localisation impossible, merci d'activer votre service de localisation "delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

    
    
}


/* Action qui permet de arrete l'update en boucle de la localisation */
/*      Relié au boutton stop                                        */
-(IBAction)stopMe:(UIButton *)sender{
    
    // On sauvegarde les données
    [self save];
    
    // On arrete l'updating
    [self.brain arreter];

    
}



-(void)update:(NSString *) distance location: (CLLocation*) newLocation speed: (CLLocationSpeed) speed distanceJournaliere:(NSString *)distancesJournaliere distanceSession:(NSString *)distancesSession for:(TrackingBrain *) requestor{

    
    [self.distanceTotal setText: [NSString stringWithFormat:@"distance: %@", distance]];
    [longitude setText: [NSString stringWithFormat:@"longitude: %f", newLocation.coordinate.longitude]];
    [self.latitude setText: [NSString stringWithFormat:@"latitude: %f", newLocation.coordinate.latitude]];
    [self.vitesse setText:[NSString stringWithFormat:@"vitesse: %f Km/h", speed*3.6]];
    [self.distanceSession setText: [NSString stringWithFormat:@"Distance Session: %@", distancesSession]];
    [self.distanceJournaliere setText: [NSString stringWithFormat:@"Distance Journaliere: %@", distancesJournaliere]];
    [self save];
    
    



}


/* Methode qui va cherché les info present dans un fichier et retourn un dictionnaire les */ 
/* contenents ( return null si le fichier n'existe pas )  */
- (NSMutableDictionary *)load{
    
    //Cherche et crée le path où est stocké le fichier .plist ( ici dans le repertoire Document)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];
    
    
    //crée un dictionnaire à partir des donée du fichier recuperé
    NSMutableDictionary *content = [[NSMutableDictionary alloc] initWithContentsOfFile:path ];
    
    [content autorelease];
    //retourne ce dictionnaire
    return content;
}

/*cree une alerte qui va reseter le brain et le fichier de sauvegrde si l'utilisateur valide */
-(IBAction)reset:(UIButton*) sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Toute les données vont etre effacée! Continuer? "delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ok", nil];
    [alert show];
    [alert release];
    
}

/*deleger a alerte*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Annuler"])
    {
        
    }
    else if([title isEqualToString:@"Ok"])
    {
        [self.brain arreter];
        [self.brain reset];
        [self save];
        //On met a jour l'interface graphique

        [distanceTotal setText: [NSString stringWithFormat:@"distance: %@", [self.brain formatDistance:self.brain.distanceTotal]]];
        [distanceJournaliere setText: [NSString stringWithFormat:@"distance Journaliere: %@", [self.brain formatDistance:self.brain.distanceJournaliere]]];
        [distanceSession setText: [NSString stringWithFormat:@"distance Session: %@", [self.brain formatDistance:self.brain.distanceSession]]];
    }
}

/*Methode qui va ecrire les données dans un fichier properties.plist situé dans le repertoire Document
  le fichier est crée si inexistant et ecrasé si existant*/
- (void) save{
    
    //recupere le chemin vers le repertoir Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // ajoute le nom de fichier
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"properties.plist"];


    // recupere les données dans un dictionnaire et les ecrits dans le fichier
    [[self.brain getDicoForSave] writeToFile:path atomically:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
