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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index  {
    return [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{ 
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString 
                                                                  stringWithFormat:@"%f", [[[self.dataForPlot objectAtIndex: index] objectForKey:@"y"] floatValue]]] ; 
    return textLayer; 
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /***************/
    /***************/
    //Juste des données de test
    //Il faudra traiter cette partie lors dans le ViewController dans le bouton qui affiche le graphe
    //A ce moment là les données du tableau h24 seront copiés dans dataForPlot
    
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:24];
	NSUInteger i;
	for ( i = 0; i < 24; i++ ) {
        id x = [NSNumber numberWithFloat:i];
        id y = [NSNumber numberWithFloat:(rand() / (float)RAND_MAX) * 1000];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPlot = contentArray;
    
    
    /****************/
    /****************/
    
    // Creation graphique
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    // Theme du graphique
	CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
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
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.2) length:CPTDecimalFromFloat(8)]; // Les 6 premières heures
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-130) length:CPTDecimalFromInt(1000)];// environ 800m
    
    // Axe X
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.minorTicksPerInterval = 0;
    
    // Axe Y
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"250");
    y.minorTicksPerInterval = 4;
    //un point tout les 50m
    
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
    
    
}

- (void)viewDidUnload
{
    [graph release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
