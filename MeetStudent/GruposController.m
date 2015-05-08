//
//  GruposController.m
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "GruposController.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>
#import "Section.h"
#import "PessoasController.h"

@interface GruposController ()

@end

@implementation GruposController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataGroups];
    //define title Navigation Item
    Section *singleton = [Section section];
    self.navigationItem.title = singleton.instituition;
    
    self.SearchBarGroup.delegate   = self;
    self.TableViewGroup.delegate   = self;
    self.TableViewGroup.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//|-------------------------------------------------
//|Return information of the database
- (void)loadDataGroups
{
    Section *singleton = [Section section];
    _instituitionId = singleton.instituitionId;
    
    PFQuery *query = [PFQuery queryWithClassName:@"grupo"];
    [query whereKey:@"pk_instituicao" equalTo:_instituitionId];
    
    _totalGroups    = [[NSMutableArray alloc]init];
    _totalGroupsIds = [[NSMutableArray alloc]init];
    
    NSArray *result = [query findObjects];
    
    for (PFObject *group in result){
        [_totalGroups addObject:group[@"nome"]];
        [_totalGroupsIds addObject:[group objectId]];
    }
}

//|-------------------------------------------------
//|Search word on totalGroups and return filtered groups
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _isFiltered = NO;
    } else {
        _isFiltered = YES;
        
        _filteredGroups    = [[NSMutableArray alloc]init];
        _filteredGroupsIds = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [_totalGroups count]; i++) {
            NSRange stringRange = [_totalGroups[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange.location != NSNotFound) {
                [_filteredGroups addObject:_totalGroups[i]];
                [_filteredGroupsIds addObject:_totalGroupsIds[i]];
            }
        }
    }
    [self.TableViewGroup reloadData];
}

//|-------------------------------------------------
//|If search button clicked hidden keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.TableViewGroup resignFirstResponder];
}

//|-------------------------------------------------
//|Return number of sections on table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//|-------------------------------------------------
//|Return number of rows of table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFiltered) {
        return [_filteredGroups count];
    }
    return [_totalGroups count];
}

//|-------------------------------------------------
//|Inject information of the database in table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellGroup";
    UITableViewCell *cell = [_TableViewGroup dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (!_isFiltered) {
        cell.textLabel.text = [_totalGroups objectAtIndex:indexPath.row];
    } else { // is Filtered
        cell.textLabel.text = [_filteredGroups objectAtIndex:indexPath.row];
    }
    return cell;
}

//|-------------------------------------------------
//|Add section of Instituition current
- (void)sectionCurrent:(NSString *)cellCurrent id:(NSString *)cellCurrentId
{
    //alloc singleton
    Section *singleton = [Section section];
    
    //set group current
    [singleton setGroup:cellCurrent];
    [singleton setGroupId:cellCurrentId];
}

//|-------------------------------------------------
//|send group current on peoples controller and add group on singleton
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.TableViewGroup indexPathForSelectedRow];
//    PessoasController *PC;
    
    if (_isFiltered) {
        //set group current on singleton
        [self sectionCurrent:[_filteredGroups objectAtIndex:path.row]
                          id:[_filteredGroupsIds objectAtIndex:path.row]];
    }else{
        //set group current on singleton
        [self sectionCurrent:[_totalGroups objectAtIndex:path.row]
                          id:[_totalGroupsIds objectAtIndex:path.row]];
    }
    //Send to gruposViewController
    PessoasController *PC = [segue destinationViewController];
    NSLog(@" pc -> %@", PC);
}

//|-------------------------------------------------
//|Return for grupo mainview controller
- (IBAction)returnGrupoMainViewController:(UIStoryboardSegue*)sender
{
}

@end
