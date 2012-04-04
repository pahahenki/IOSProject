//
//  TrakingBrain.h
//  TrakingVRP
//
//  Created by SWAN ENGILBERGE on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TrackingBrain : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locMgr;
    id delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic) double distanceTotal;




-(double) calcultDistanceIntermediaireFrom: (const CLLocation *) previousLocation to: (const CLLocation *) myLocation;

-(CLLocation *) getLocation;



@end
