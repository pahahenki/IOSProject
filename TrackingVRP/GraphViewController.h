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
    CPTGraphHostingView *graphView;
    CPTXYGraph *graph;
}

@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
@property(readwrite, retain, nonatomic) NSMutableArray *h24G;
@property(readwrite, retain, nonatomic) NSMutableArray *semaineG;


-(void) dessinerGraph;
-(id) initWithData: (NSMutableArray *) h24 semaine:(NSMutableArray *) semaine ;
-(IBAction)semaineB:(UIButton*) sender;
-(IBAction)jourB:(UIButton*) sender;


@end
