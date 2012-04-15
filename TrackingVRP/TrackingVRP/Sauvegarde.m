//
//  Sauvegarde.m
//  TrackingVRP
//
//  Created by SWAN ENGILBERGE on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sauvegarde.h"

@implementation Sauvegarde

@synthesize distanceTotal,distanceParHeure, distanceDutour;
@synthesize heureActuelleString;
@synthesize h24;



- (id)init
{
    self = [super init];
    if (self) {
        distanceTotal = 0;
        distanceDutour = 0;
        distanceParHeure = 0;
        h24 = [[NSMutableArray alloc] initWithCapacity:24];
        for(int i = 0; i < 24; i++){
            [h24 insertObject:[NSNumber numberWithDouble:0] atIndex:i];
        }
    }
    return self;
}

- (void) dealloc{
    [h24 dealloc];
    [super dealloc];
}


- (void) encodeWithCoder:(NSCoder *) encoder
{
    [encoder encodeDouble:distanceTotal forKey:@"distanceTotal"];
    [encoder encodeDouble:distanceParHeure forKey:@"distanceParHeure"];
     [encoder encodeObject:heureActuelleString forKey:@"heureActuelleString"];
    [encoder encodeObject:h24 forKey:@"h24"];

     
      
}

- (id) initWithCoder:(NSCoder *) decoder
{
    self = [super init];
    if (self) {
        distanceTotal = [decoder decodeDoubleForKey:@"distanceTotal"];
        distanceParHeure = [decoder decodeDoubleForKey:@"distanceParHeure"];
        heureActuelleString = [[decoder decodeObjectForKey:@"heureActuelleString"] retain];
        h24 = [[decoder decodeObjectForKey:@"h24"] retain];

    }
    
    return self;
}

@end
