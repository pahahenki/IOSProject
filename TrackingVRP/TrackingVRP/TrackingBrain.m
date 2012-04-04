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
        self.locMgr =  [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
        [self.locMgr startUpdatingLocation];
    }
    return self;
}

-(CLLocation *) getLocation{
    return self.locMgr.location;
}



-(double) calcultDistanceIntermediaireFrom: (const CLLocation *) previousLocation to: (const CLLocation *) myLocation{
    return 0;
}

@end
