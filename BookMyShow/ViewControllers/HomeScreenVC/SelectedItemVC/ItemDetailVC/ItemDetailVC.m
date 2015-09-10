//
//  ItemDetailVC.m
//  BookMyShow
//
//  Created by Fstech042 on 09/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import "HeaderFiles.h"
#import "AppDelegate.h"

@interface ItemDetailVC()

{
    IBOutlet UIImageView *imgShopImage;
    IBOutlet UILabel *lblOpeningTime;
    IBOutlet UILabel *lblVicinity,*lblName;
    IBOutlet UITextView *txtVicinity;
    
    NSString *strShopname;
    NSString *strPhotoReference;
    
    float lat,lng;
    
    NSString *strLocName,*strLocAddress;
    NSString *  isOpen;
    
    BOOL isPhoto;
    
    NSData *imgData;
}

@end


@implementation ItemDetailVC
@synthesize detailList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Details";
    [self addBarBTn];
    NSLog(@"%@",self.detailList);
    NSArray *arrVici = [self.detailList valueForKey:@"vicinity"];
     NSArray *arrName = [self.detailList valueForKey:@"name"];
    NSDictionary *temp = [[[self.detailList objectAtIndex:0] valueForKey:@"geometry"] objectForKey:@"location"];
    lat=[[temp objectForKey:@"lat"]floatValue];
    lng=[[temp objectForKey:@"lng"]floatValue];
    isPhoto = NO;
    
    if([[self.detailList objectAtIndex:0] valueForKey:@"opening_hours"])
    {
        NSDictionary *open = [[self.detailList objectAtIndex:0] valueForKey:@"opening_hours"];
        
     NSString * strisOpen = [open objectForKey:@"open_now"];
     BOOL  isOpenBool = [strisOpen boolValue];
      
        if(!isOpenBool )
        {
            lblOpeningTime.text = @"Closed";
            isOpen = @"0";
        }
        else if(isOpenBool)
        {
            lblOpeningTime.text = @"Open";
            isOpen = @"1";
        }
  
        
    }
    else
        lblOpeningTime.text = @"N/A";
    isOpen = @"N/A";
    
    
   
    if( [[self.detailList objectAtIndex:0]objectForKey:@"photos"])
   {
       NSArray *temp = [[self.detailList objectAtIndex:0] valueForKey:@"photos"];
       NSDictionary *temp1 = [temp objectAtIndex:0];
       NSString *temp2 = [temp1 valueForKey:@"photo_reference"];
       isPhoto = YES;
       [self requestForImage:temp2];
   }
    else
    {
        UIImage *image = [UIImage imageNamed:@"SorryNoImageAvailable.jpg"];
        imgData = UIImageJPEGRepresentation(image, 100);
    }
    
    lblName.text = [arrName objectAtIndex:0];
    strLocName = [arrName objectAtIndex:0];
    
    [lblVicinity sizeToFit];

    txtVicinity.text=[arrVici objectAtIndex:0];
    strLocAddress =[arrVici objectAtIndex:0];
   // NSString *strPhotoTef = [arrPR objectAtIndex:0];
  
  // if(strPhotoTef == nil)
  // [self requestForImage:strPhotoTef];
   
    
}


- (void)requestForImage:(NSString*)toSearch
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=AIzaSyBHO7ecGIyNN9mrjCbBV79WImtHap_Vg0Y",toSearch];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        imgShopImage.image = responseObject;
        imgData = UIImageJPEGRepresentation(responseObject, 100);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

- (IBAction)didTapMap:(id)sender
{
  MapViewVC *mp = (MapViewVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewVC"];
    mp.lat = lat;
    mp.lng = lng;
    mp.name = strLocName;
    mp.address = strLocAddress;
    
    mp.modalPresentationStyle =   UIModalTransitionStyleCrossDissolve;
    
    [self.navigationController pushViewController:mp animated:YES];
    
                               
}

- (void)addBarBTn
{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 40, 40)];
    [btnRight setImage:[UIImage imageNamed:@"favorite21.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(addToFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * satBtn = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [satBtn setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:satBtn];
}

- (void)addToFav
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Fav"];
   NSArray *fetchedData = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    

    
     NSArray *arrId = [self.detailList valueForKey:@"id"];
    NSString *strId = [arrId objectAtIndex:0];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"id contains[c] %@", strId];
    NSArray *searchedResult = [fetchedData filteredArrayUsingPredicate:resultPredicate];
    
    if([searchedResult count]>0)
    {
        [self showAlert:@"This is already added"];
        return;
    }
    
    // Create a new managed object
    NSManagedObject *fav = [NSEntityDescription insertNewObjectForEntityForName:@"Fav" inManagedObjectContext:context];
    [fav setValue:strLocName forKey:@"name"];
    [fav setValue:strLocAddress forKey:@"address"];
    [fav setValue:isOpen forKey:@"open"];
    [fav setValue:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
    [fav setValue:[NSString stringWithFormat:@"%f",lng] forKey:@"lng"];
     [fav setValue:strId forKey:@"id"];
    if(isPhoto)
    {
        [fav setValue:imgData forKey:@"image"];
    }
    else
    {
        [fav setValue:imgData forKey:@"image"];

    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        [self showAlert:@"Added to List"];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    isPhoto = NO;
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"BookMySHow" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [showAlert show];

}

@end
