//
//  SelectedItemVC.m
//  BookMyShow
//
//  Created by Fstech042 on 09/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//


#import "HeaderFiles.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SelectedItemVC()

{
    NSArray *itemName;
    NSArray *itemImage;
    NSArray *sampleImg;
    NSArray *idOfItems;
    
    IBOutlet UITableView *myTable;
}

@end


@implementation SelectedItemVC
@synthesize fetchedData;
@synthesize selectedType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    itemName = [self.fetchedData valueForKey:@"name"];
    itemImage = [self.fetchedData valueForKey:@"icon"];
    sampleImg = itemsListImgs;
    if(idOfItems == nil)
    {
        idOfItems = [[NSArray alloc]init];
    }
    idOfItems = [self.fetchedData valueForKey:@"id"];
    
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [self.selectedType uppercaseString];;
    [self addBarBTn];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedData count]
    ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    cell.textLabel.text = [itemName objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.selectedType];
    
    
    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[itemImage objectAtIndex:indexPath.row]]];
        if (imgData)
        {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                        cell.imageView.image = image;
                });
            }
        }
    });

 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *searchedResult;
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"id contains[c] %@", [idOfItems objectAtIndex:indexPath.row]];
    searchedResult = [self.fetchedData filteredArrayUsingPredicate:resultPredicate];

    ItemDetailVC *nxtScr = (ItemDetailVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
    nxtScr.detailList = searchedResult;
    [self.navigationController pushViewController:nxtScr animated:YES];
    
    
}


- (void)addBarBTn
{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 20)];
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
