//
//  PessoasController.h
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PessoasController : UITableViewController <UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarPeople;
@property (strong, nonatomic) IBOutlet UITableView *TableViewPeople;

@property (nonatomic) NSString *group;
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *instituitionId;

@property (nonatomic) NSMutableArray *totalPeoplesId;
@property (nonatomic) NSMutableArray *totalPeoples;
@property (nonatomic) NSMutableArray *totalPeoplesImg;
@property (nonatomic) NSMutableArray *filteredPeoples;
@property (nonatomic) NSMutableArray *filteredPeoplesId;
@property (nonatomic) NSMutableArray *filteredPeoplesImg;

@property (nonatomic) BOOL isFiltered;

@end
