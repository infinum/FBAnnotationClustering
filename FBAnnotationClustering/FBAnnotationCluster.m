//
//  FBAnnotationCluster.m
//  AnnotationClustering
//
//  Created by Filip Bec on 06/01/14.
//  Copyright (c) 2014 Infinum Ltd. All rights reserved.
//

#import "FBAnnotationCluster.h"

@implementation FBAnnotationCluster

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F", self.coordinate.latitude, self.coordinate.longitude];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    static const double kSmallValue = 1e-5;
    
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[FBAnnotationCluster class]]) {
        return NO;
    } else {
        FBAnnotationCluster *cluster = object;
        return self.annotations.count == cluster.annotations.count &&
               ABS(self.coordinate.latitude - cluster.coordinate.latitude) < kSmallValue &&
               ABS(self.coordinate.longitude - cluster.coordinate.longitude) < kSmallValue;
    }
}

@end
