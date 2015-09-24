//
//  FBViewController.m
//  AnnotationClustering
//
//  Created by Filip Bec on 06/04/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FBViewController.h"
#import "FBAnnotation.h"

#define kNUMBER_OF_LOCATIONS 1000
#define kFIRST_LOCATIONS_TO_REMOVE 50

@interface FBViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAnnotationsLabel;

@property (nonatomic, assign) NSUInteger numberOfLocations;
@property (nonatomic, strong) FBClusteringManager *clusteringManager;

@end

@implementation FBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSMutableArray *array = [self randomLocationsWithCount:kNUMBER_OF_LOCATIONS];
    self.numberOfLocations = kNUMBER_OF_LOCATIONS;
    [self updateLabelText];
    
    // Create clustering manager
    self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:array];
    self.clusteringManager.delegate = self;
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
    [self mapView:self.mapView regionDidChangeAnimated:NO];

    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] init];
    for (int i=0; i<kFIRST_LOCATIONS_TO_REMOVE; i++) {
        [annotationsToRemove addObject:array[i]];
    }
    [self.clusteringManager removeAnnotations:annotationsToRemove];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotatioViewReuseID];
    }
    
    // This is how you can check if annotation is a cluster
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        cluster.title = [NSString stringWithFormat:@"%lu", (unsigned long)cluster.annotations.count];
        
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
    } else {
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = NO;
    }
    
    return annotationView;
}

#pragma mark - FBClusterManager delegate - optional

- (CGFloat)cellSizeFactorForCoordinator:(FBClusteringManager *)coordinator
{
    return 1.5;
}

#pragma mark - Add annotations button action handler

- (IBAction)addNewAnnotations:(id)sender
{
    NSMutableArray *array = [self randomLocationsWithCount:kNUMBER_OF_LOCATIONS];
    [self.clusteringManager addAnnotations:array];
    
    self.numberOfLocations += kNUMBER_OF_LOCATIONS;
    [self updateLabelText];
    
    // Update annotations on the map
    [self mapView:self.mapView regionDidChangeAnimated:NO];
}

#pragma mark - Utility

- (NSMutableArray *)randomLocationsWithCount:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        FBAnnotation *a = [[FBAnnotation alloc] init];
        a.coordinate = CLLocationCoordinate2DMake(drand48() * 40 - 20, drand48() * 80 - 40);
        
        [array addObject:a];
    }
    return array;
}

- (void)updateLabelText
{
    self.numberOfAnnotationsLabel.text = [NSString stringWithFormat:@"Sum of all annotations: %lu", (unsigned long)self.numberOfLocations];
}

@end
