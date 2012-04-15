//
//  Sauvegarde.h
//  TrackingVRP
//
//  Created by SWAN ENGILBERGE on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sauvegarde : NSObject <NSCoding>{
    
    NSMutableArray *h24;
    double distanceTotal;
    double distanceDutour;
    double distanceParHeure;
    NSMutableString *heureActuelleString;
    
    
}


@property (nonatomic) double distanceTotal;
@property (nonatomic) double distanceDutour;
@property (nonatomic) double distanceParHeure;
@property (nonatomic, retain) NSMutableString *heureActuelleString;
@property (nonatomic, retain) NSMutableArray *h24;


- (id) init;
- (id) initWithCoder:(NSCoder *) decoder;
- (void) encodeWithCoder:(NSCoder *) encoder;


@end
