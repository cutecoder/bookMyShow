//
//  SelectedItemVC.h
//  BookMyShow
//
//  Created by Fstech042 on 09/09/15.
//  Copyright (c) 2015 RahulMishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedItemVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong) NSArray *fetchedData;
@property (strong) NSString *selectedType;

@end
