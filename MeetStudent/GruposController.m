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

@interface GruposController ()

@end

@implementation GruposController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataGroups];
    
    self.SearchBarGroup.delegate   = self;
    self.TableViewGroup.delegate   = self;
    self.TableViewGroup.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//|-------------------------------------------------
//|Search word on database and return filtered groups
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if (searchText.length == 0) {
//        _isFiltered = NO;
//    } else {
//        _isFiltered = YES;
//        _filteredGroups = [[NSMutableArray alloc]init];
//        
//        PFQuery *query = [PFQuery queryWithClassName:@"grupo"];
//        [query whereKey:@"nome" equalTo:searchText];
//        
//        _filteredGroups = [[NSMutableArray alloc]init];
//        NSArray *result = [query findObjects];
//        
//        for (PFObject *group in result){
//            [_filteredGroups addObject:group[@"nome"]];
//        }
//    }
//    [self.TableViewGroup reloadData];
//}

//|-------------------------------------------------
//|If search button clicked hidden keyboard
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [self.TableViewGroup resignFirstResponder];
//}

//|-------------------------------------------------
//|Return information of the database
- (void)loadDataGroups
{
    Section *singleton = [Section section];
    _instituitionId = singleton.instituitionId;
    
    PFQuery *query = [PFQuery queryWithClassName:@"grupo"];
    [query whereKey:@"pk_instituicao" equalTo:_instituitionId];
    
    _totalGroups = [[NSMutableArray alloc]init];
    
    NSArray *result = [query findObjects];
    
    for (PFObject *group in result){
        [_totalGroups addObject:group[@"nome"]];
    }
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
//|Return for grupo mainview controller
- (IBAction)returnGrupoMainViewController:(UIStoryboardSegue*)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
