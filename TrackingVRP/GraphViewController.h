//
//  GraphViewController.h
//  TrackingVRP
//
//  Created by SWAN ENGILBERGE on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GraphViewController : UIViewController  <CPTPlotDataSource> {
    NSMutableArray *dataForPlot;
    CPTXYGraph *graph;
}

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

@end
