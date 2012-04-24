//
//  GraphViewController.m
//  TrackingVRP
//
//  Created by SWAN ENGILBERGE on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"




@implementation GraphViewController

@synthesize dataForPlot;
@synthesize h24G, semaineG;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithData: (NSMutableArray *) journee semaine: (NSMutableArray *) semaine{
    self = [super init];
    if (self){
        self.h24G = [NSMutableArray arrayWithCapacity:24];
        NSUInteger i;
        for ( i = 0; i < 24; i++ ) {
            id x = [NSNumber numberWithFloat:i + 0.5] ;
            id y = [NSNumber numberWithDouble:[[journee objectAtIndex:i] doubleValue] /1000];
            [h24G addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
            
        }
        
        self.semaineG = [NSMutableArray arrayWithCapacity:7];
        for ( i = 0; i < 7; i++ ) {
            id x = [NSNumber numberWithFloat:i + 0.5] ;
            id y = [NSNumber numberWithDouble:[[semaine objectAtIndex:i] doubleValue] /1000];
            [semaineG addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
            
        }
        
        self.dataForPlot = h24G;
    }
    return self;
    
}

-(void) dealloc{
    [h24G release];
    [semaineG release];
    [dataForPlot release];
    [super dealloc];
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
    return [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{ 
    NSString *text = @"";
    if ([[[self.dataForPlot objectAtIndex: index] objectForKey:@"y"] floatValue] !=  0) {
        text = [NSString stringWithFormat:@"%.0f", [[[self.dataForPlot objectAtIndex: index] objectForKey:@"y"] floatValue]];
    }
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:text]; 
    [textLayer autorelease];
    return textLayer; 
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [graph release];
    [super viewDidUnload];

}

-(void) dessinerGraph{
    
    // Creation graphique

   

    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    // Theme du graphique
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    
    UIView * hostingView = self.view;
    
    graph.paddingLeft = 0.0;
	graph.paddingTop = 0.0;
	graph.paddingRight = 0.0;
	graph.paddingBottom = 0.0;
    
    CPTGraphHostingView *graphHostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 320, 375)];
    graphHostingView.collapsesLayers = NO;
    [hostingView addSubview:graphHostingView];
    
    graphHostingView.hostedGraph = graph;
    
    // Limite d'affichage de la vue par rapport à l'échelle des axes (voir les axes et les valeurs sur les axes)
    double max = [[[dataForPlot objectAtIndex:0] objectForKey:@"y"] doubleValue];
    for (int i =0; i < [dataForPlot count]; i++) {
        if ([[[dataForPlot objectAtIndex:0] objectForKey:@"y"] doubleValue]>max) {
            max = [[[dataForPlot objectAtIndex:0] objectForKey:@"y"] doubleValue];
        }
    }
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    if ([dataForPlot count] == 24) {
        plotSpace.allowsUserInteraction = YES;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.2) length:CPTDecimalFromFloat(8)]; // Les 6 premières heures
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) length:CPTDecimalFromInt(1000)];// environ 800m

    }
    if ([dataForPlot count] == 7) {
        plotSpace.allowsUserInteraction = NO;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.6) length:CPTDecimalFromFloat(9)]; // Les 7 Jour
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1000) length:CPTDecimalFromInt(10000)];// environ 800m

    }       
    // Axe X
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.minorTicksPerInterval = 0;
    if ([dataForPlot count] == 24) {
        x.title = @"Heure";
    }
    if ([dataForPlot count] == 7) {
        x.title = @"Jour";
    }
    
    

    
    // Axe Y
    CPTXYAxis *y = axisSet.yAxis;
    if ([dataForPlot count] == 24) {
        y.majorIntervalLength = CPTDecimalFromString(@"250");
        y.minorTicksPerInterval = 4;//un point tout les 50m
    }
    if ([dataForPlot count] == 7) {
        y.majorIntervalLength = CPTDecimalFromString(@"2500");
        y.minorTicksPerInterval = 4;//un point tout les 50m
    }


    
    
    // Ligne du graphique
    //	CPTScatterPlot *boundLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    //    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    //    lineStyle.miterLimit = 10.0f;
    //	lineStyle.lineWidth = 3.0f;
    //	lineStyle.lineColor = [CPTColor redColor];
    //    boundLinePlot.dataLineStyle = lineStyle;
    //    boundLinePlot.identifier = @"Red Plot";
    //    boundLinePlot.dataSource = self;
    //	[graph addPlot:boundLinePlot];
    
    
    // barPlot
    //    CPTMutableTextStyle *myTextStyle = [[[CPTMutableTextStyle alloc] init] autorelease];
    //    myTextStyle.color = [CPTColor redColor];
   
    CPTBarPlot *barPlot = [[CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO] autorelease];
    //    barPlot.labelTextStyle = myTextStyle;
    barPlot.delegate = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");

    barPlot.dataSource = self;
    [graph addPlot:barPlot];
    [graphHostingView release];

    
}

-(IBAction)semaineB:(UIButton*) sender{
    
    self.dataForPlot = self.semaineG;
    [self dessinerGraph];
}

-(IBAction)jourB:(UIButton*) sender{
    self.dataForPlot = self.h24G;
    [self dessinerGraph];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
