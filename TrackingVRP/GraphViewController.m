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
    
    
    /*CPTTextStyle *style = [[CPTTextStyle alloc] init];
     style.color = [[CPTColor alloc] initWithComponentRed:223 green:223 blue:223 alpha:1]];*/
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:text]; 
    //textLayer setTextStyle:style];
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


/* fonction qui dessine le graphe */

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
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) length:CPTDecimalFromInt(400)];// environ 800m
        
    }
    if ([dataForPlot count] == 7) {
        plotSpace.allowsUserInteraction = NO;
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.6) length:CPTDecimalFromFloat(9)]; // Les 7 Jour
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-400) length:CPTDecimalFromInt(2000)];// environ 800m
        
        
    }       
    // Axe X
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
   
    

    if ([dataForPlot count] == 24) {
        x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"1"] decimalValue];
        CPTPlotRange *xAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0") length:CPTDecimalFromString(@"23.0")];
        x.minorTicksPerInterval = 0;
        x.minorTickLength = 5.0f;
        x.majorTickLength = 7.0f;
        x.visibleRange=xAxisRange;
        x.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
        x.title=@"Hours";
        x.titleOffset=40.0f;
        x.labelRotation=M_PI/4;
        x.labelingPolicy=CPTAxisLabelingPolicyNone;
        NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:0],[NSDecimalNumber numberWithInt:1],[NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6], [NSDecimalNumber numberWithInt:7], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:9], [NSDecimalNumber numberWithInt:10], [NSDecimalNumber numberWithInt:11], [NSDecimalNumber numberWithInt:12], [NSDecimalNumber numberWithInt:13], [NSDecimalNumber numberWithInt:14],[NSDecimalNumber numberWithInt:15], [NSDecimalNumber numberWithInt:16], [NSDecimalNumber numberWithInt:17], [NSDecimalNumber numberWithInt:18], [NSDecimalNumber numberWithInt:19], [NSDecimalNumber numberWithInt:20], [NSDecimalNumber numberWithInt:21], [NSDecimalNumber numberWithInt:22], [NSDecimalNumber numberWithInt:23],nil];
        
        NSArray *xAxisLabels = [NSArray arrayWithObjects:@"0H",@"1H", @"2H", @"3H", @"4H", @"5H", @"6 H", @"7H", @"8H", @"9 H", @"10H", @"11H", @"12H", @"13H", @"14H", @"15H", @"16H", @"17H", @"18H", @"19H", @"20H", @"21H", @"22H", @"23H", nil];
        NSUInteger labelLocation = 0;
        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
        for (NSNumber *tickLocation in customTickLocations) 
        {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
            newLabel.tickLocation = [tickLocation decimalValue];
            newLabel.offset = x.labelOffset + x.majorTickLength;
            newLabel.rotation = M_PI/4;
            [customLabels addObject:newLabel];
            [newLabel release];
        }
        x.axisLabels =  [NSSet setWithArray:customLabels];
        
        
    }
    if ([dataForPlot count] == 7) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        x.majorIntervalLength = [[NSDecimalNumber decimalNumberWithString:@"1"] decimalValue];
        CPTPlotRange *xAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0") length:CPTDecimalFromString(@"7.0")];
        x.minorTicksPerInterval = 0;
        x.minorTickLength = 5.0f;
        x.majorTickLength = 7.0f;
        x.visibleRange=xAxisRange;
        x.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
        x.title=@"jour";
        x.titleOffset=80.0f;
        x.labelRotation=M_PI/4;
        x.labelingPolicy=CPTAxisLabelingPolicyNone;
        NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1],[NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:3], [NSDecimalNumber numberWithInt:4], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:6],[NSDecimalNumber numberWithInt:7],nil];
    
        NSArray *xAxisLabels = [NSArray arrayWithArray:[timeFormatter weekdaySymbols]];
        NSUInteger labelLocation = 0;
        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
        for (NSNumber *tickLocation in customTickLocations) 
        {
            CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
            newLabel.tickLocation = [tickLocation decimalValue];
            newLabel.offset = x.labelOffset + x.majorTickLength;
            newLabel.rotation = M_PI/4;
            


            [customLabels addObject:newLabel];
            [newLabel release];
        }
        x.axisLabels =  [NSSet setWithArray:customLabels];
       
        

        
        
    }
    
    
    
    // Axe Y
    CPTXYAxis *y = axisSet.yAxis;
    CPTPlotRange *yAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0") length:CPTDecimalFromString(@"400.0")];
    y.majorIntervalLength = CPTDecimalFromString(@"100");
    if ([dataForPlot count] == 24) {

        y.minorTicksPerInterval = 4;//un point tout les 25km
        
    }
    if ([dataForPlot count] == 7) {
        yAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0.0") length:CPTDecimalFromString(@"1500")];
         y.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");

        y.majorIntervalLength = CPTDecimalFromString(@"500");
        y.minorTicksPerInterval = 4;//un point tout les 125Km
        
    }
    
    y.visibleRange=yAxisRange;
    
    
    
    // Ligne du graphique
    // barPlot
    
    CPTBarPlot *barPlot = [[CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO] autorelease];
    //    barPlot.labelTextStyle = myTextStyle;
    barPlot.delegate = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    
    barPlot.dataSource = self;
    [graph addPlot:barPlot];
    [graphHostingView release];
    
    
}

/*fonction qui redessine le graphe avec les jour a la place des heure */

-(IBAction)semaineB:(UIButton*) sender{
    
    self.dataForPlot = self.semaineG;
    [self dessinerGraph];
}

/*fonction qui redessine le graphe avec les heures a la place des jours */


-(IBAction)jourB:(UIButton*) sender{
    self.dataForPlot = self.h24G;
    [self dessinerGraph];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
