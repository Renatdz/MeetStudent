//
//  GruposController.h
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GruposController : UITableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarGroup;
@property (strong, nonatomic) IBOutlet UITableView *TableViewGroup;

@property (nonatomic) NSString *instituition;
@property (nonatomic) NSString *instituitionId;

@property (nonatomic) NSMutableArray *totalGroupsIds;
@property (nonatomic) NSMutableArray *totalGroups;
@property (nonatomic) NSMutableArray *filteredGroups;
@property (nonatomic) NSMutableArray *filteredGroupsIds;

@property (nonatomic) BOOL isFiltered;

@end
