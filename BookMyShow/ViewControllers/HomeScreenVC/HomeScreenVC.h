//
//  HomeScreenVC.h
//  BookMyShow
//
//  Created by Fstech042 on 09/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeScreenVC : UIViewController<CLLocationManagerDelegate>

- (IBAction)didTapItems:(id)sender;

@end
