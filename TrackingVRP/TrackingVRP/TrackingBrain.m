//
//  TrakingBrain.m
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingBrain.h"


@implementation TrackingBrain

@synthesize distanceTotal;
@synthesize locMgr;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.distanceTotal = 0;
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
        [self.locMgr startUpdatingLocation];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(CLLocation *) getLocation{
    return self.locMgr.location;
}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
 
    self.distanceTotal += (double) [oldLocation distanceFromLocation:newLocation];
    NSLog(@"%f, %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
}

-(double) calcultDistanceIntermediaireFrom: (const CLLocation *) previousLocation to: (const CLLocation *) myLocation{
    return 0;
}

@end
