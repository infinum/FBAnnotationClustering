//
//  FBAnnotationTwo.h
//  AnnotationClustering
//
//  Created by Jeff Avery on 2015-06-30.
//  Copyright (c) 2015 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface FBAnnotationTwo : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
