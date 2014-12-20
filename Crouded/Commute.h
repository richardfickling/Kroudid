//
//  WorkRoute.h
//  Crouded
//
//  Created by Scott Sirowy on 12/19/14.
//  Copyright (c) 2014 App Builders Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface Commute : NSObject

@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSDate* endDate;

@property (nonatomic, strong, readonly) AGSPoint* p1;
@property (nonatomic, strong, readonly) AGSPoint* p2;

@property (nonatomic, strong) AGSGeometry* p1Geofence;
@property (nonatomic, strong) AGSGeometry* p2Geofence;

// Reference to a gps so we can track when user goes in and out of an area
@property (nonatomic, weak) AGSLocationDisplay* gps;

- (id)initWithPoint1:(AGSPoint*)p1
              point2:(AGSPoint*)p2;

- (void)startCommute;
- (void)endCommuteAndReachedDestination:(BOOL)reached;

- (BOOL)atHomeOrAtWork;

@end
