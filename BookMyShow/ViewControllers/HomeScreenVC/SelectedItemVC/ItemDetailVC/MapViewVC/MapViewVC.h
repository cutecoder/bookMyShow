//
//  MapViewVC.h
//  BookMyShow
//
//  Created by Fstech042 on 10/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewVC : UIViewController<MKMapViewDelegate>

@property float lat,lng;
@property (strong) NSString *name,*address;

@end
