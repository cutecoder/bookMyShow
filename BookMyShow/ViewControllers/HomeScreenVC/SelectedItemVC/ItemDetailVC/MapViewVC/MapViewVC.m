//
//  MapViewVC.m
//  BookMyShow
//
//  Created by Fstech042 on 10/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import "MapViewVC.h"

@interface MapViewVC()

{
    IBOutlet MKMapView *map;
    int flag;
    
    UIBarButtonItem *satBtn,*mapBtn;
}

@end

@implementation MapViewVC
@synthesize lat,lng;

- (void)viewWillAppear:(BOOL)animated
{
    CLLocation * location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    
    flag = 0;
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
    [map setRegion:[map regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate =location.coordinate;
    point.title =self.name;
    point.subtitle = self.address;
    
    [map addAnnotation:point];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 44)];
    [btnRight setImage:[UIImage imageNamed:@"satView.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    satBtn = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [satBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:satBtn];
    
    UIButton *btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMap setFrame:CGRectMake(0, 0, 30, 44)];
    [btnMap setImage:[UIImage imageNamed:@"mapView.png"] forState:UIControlStateNormal];
    [btnMap addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
    mapBtn = [[UIBarButtonItem alloc] initWithCustomView:btnMap];
    [mapBtn setTintColor:[UIColor whiteColor]];
   
    self.navigationItem.title = @"Locate ME";
    

}

- (void)changeType
{
   if(flag)
   {
       map.mapType = MKMapTypeStandard;
       flag = 0;
       self.navigationItem.rightBarButtonItem = satBtn;

   }
    else
    {
      map.mapType = MKMapTypeSatellite;
        flag =1;
        self.navigationItem.rightBarButtonItem = mapBtn;
    }
}

@end
