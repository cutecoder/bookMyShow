//
//  FavListVC.m
//  BookMyShow
//
//  Created by Fstech042 on 10/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import "FavListVC.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface FavListVC()

{
    IBOutlet UITableView *myTable;
}
@property (strong) NSMutableArray *devices;
@end

@implementation FavListVC

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Fav"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if([self.devices count]==0)
    {
        UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"BookMySHow" message:@"No Fav Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [showAlert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
        myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [myTable reloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devices count];    ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"name"]]];
    NSData *imgData =[device valueForKey:@"image"];
    
    if(imgData)
    cell.imageView.image = [UIImage imageWithData:imgData];
  
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}
@end
