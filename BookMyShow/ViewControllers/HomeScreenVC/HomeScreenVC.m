//
//  HomeScreenVC.m
//  BookMyShow
//
//  Created by Fstech042 on 09/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import "HomeScreenVC.h"
#import "HeaderFiles.h"
#import "AppDelegate.h"


@interface HomeScreenVC()

{
    NSArray *arrItems,*arrItemImgs;
    IBOutlet UITableView *tableData;
    IBOutlet UISlider *sldDistance;

}

@end

@implementation HomeScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrItems=itemsList;
    arrItemImgs = itemsListImgs;

    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addBarBTn];
    self.navigationItem.title = @"Grab Your Deal";
}

- (void)makeHTTPRequest:(NSString *)toSearch location:(CLLocationCoordinate2D)myLoc distance:(int)distance
{
    
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Fetching %@ info",toSearch]];
#if TARGET_IPHONE_SIMULATOR
#define FAKE_CORE_LOCATION 1 
#endif

#ifdef FAKE_CORE_LOCATION
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=12.9667,77.5667&radius=10000&types=food&key=AIzaSyBHO7ecGIyNN9mrjCbBV79WImtHap_Vg0Y"];

#else
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%d&types=%@&key=AIzaSyBHO7ecGIyNN9mrjCbBV79WImtHap_Vg0Y",myLoc.latitude,myLoc.longitude,distance, toSearch];
#endif
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *JsonDict  = [[NSDictionary alloc]initWithDictionary:responseObject];
         NSArray *fetchedResult = [JsonDict valueForKey:@"results"];
         

         [SVProgressHUD dismiss];
         
         if([fetchedResult count]==0)
         {
             UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"BookMySHow" message:@"Nothing Found Near You" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [showAlert show];
             return;
         }
         
         SelectedItemVC *nxtScr = (SelectedItemVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectedItemVC"];
         nxtScr.fetchedData = fetchedResult;
         nxtScr.selectedType = toSearch;
         [self.navigationController pushViewController:nxtScr animated:YES];
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD dismiss];
         
         UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"BookMySHow" message:@"Unable to Connect. Please Try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [showAlert show];
         NSLog(@"Error: %@", error);
     }];

}

- (IBAction)didTapItems:(id)sender
{
    
    AppDelegate *ap =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    int val = (int)sldDistance.value;
    val = val*10;
   
    if([sender tag] == 1)
    {
        [self makeHTTPRequest:@"spa" location:ap.myLocation distance:val];
    }
    else if([sender tag] == 2)
    {
        [self makeHTTPRequest:@"school" location:ap.myLocation distance:val];
    }
    else if([sender tag] == 3)
    {
        [self makeHTTPRequest:@"food" location:ap.myLocation distance:val];
         }
    else if([sender tag] == 4)
    {
        [self makeHTTPRequest:@"gym" location:ap.myLocation distance:val];
    }
    else if([sender tag] == 5)
    {
        [self makeHTTPRequest:@"restaurant" location:ap.myLocation distance:val];
    }
    else if([sender tag] == 6)
    {
        [self makeHTTPRequest:@"hospital" location:ap.myLocation distance:val];
    }
    
}


- (void)addBarBTn
{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 30)];
    [btnRight setImage:[UIImage imageNamed:@"viewFav.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(viewFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * satBtn = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [satBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:satBtn];
}


- (void)viewFav
{
    FavListVC *nxtScr = (FavListVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"FavListVC"];

    [self.navigationController pushViewController:nxtScr animated:YES];
}

@end
