//
//  PessoasController.m
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "PessoasController.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>
#import "Section.h"
#import "PessoaController.h"

@interface PessoasController ()

@end

@implementation PessoasController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataGroups];
    
    //define title NavigationItem
    Section *singleton = [Section section];
    self.navigationItem.title = singleton.group;
    
    self.SearchBarPeople.delegate   = self;
    self.TableViewPeople.delegate   = self;
    self.TableViewPeople.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//|-------------------------------------------------
//|Return information of the database
- (void)loadDataGroups
{
    Section *singleton = [Section section];
    _groupId           = singleton.groupId;
    
    //busca o grupo na tabela relacionada
    PFQuery *query = [PFQuery queryWithClassName:@"it_group_users"];
    [query whereKey:@"pk_grupo" equalTo:_groupId];
    
    NSArray *result = [query findObjects];

    NSMutableArray *groupRelationIds = [[NSMutableArray alloc]init];
    
    for (PFObject *aa in result) {
        [groupRelationIds addObject:aa[@"pk_usuario"]];
        //NSLog(@"%@",aa[@"pk_usuario"]);
    }    
    //busca as pessoas relacionadas ao grupo
    PFQuery *query2 = [PFQuery queryWithClassName:@"usuarios"];
    [query2 whereKey:@"objectId" containedIn:groupRelationIds];

    _totalPeoples    = [[NSMutableArray alloc]init];
    _totalPeoplesId = [[NSMutableArray alloc]init];
    
    NSArray *result2 = [query2 findObjects];
    
    for (PFObject *people in result2)
    {
        NSString *name  = people[@"nome"];
        name = [name capitalizedString];
        name = [name stringByAppendingString:@" "];
        NSString *sobrenome = people[@"sobrenome"];
        sobrenome = [sobrenome capitalizedString];
        name = [name stringByAppendingString:sobrenome];
        
        [_totalPeoples addObject:name];
        [_totalPeoplesId addObject:[people objectId]];
        //NSLog(@"%@",[people objectId]);
    }
}

//|-------------------------------------------------
//|Search word on totalPeoples and return filtered peoples
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _isFiltered = NO;
    } else {
        _isFiltered = YES;
        
        _filteredPeoples = [[NSMutableArray alloc]init];
        
        for (NSString *str in _totalPeoples) {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange.location != NSNotFound) {
                [_filteredPeoples addObject:str];
            }
        }
    }
    [self.TableViewPeople reloadData];
}

//|-------------------------------------------------
//|If search button clicked hidden keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.TableViewPeople resignFirstResponder];
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
        return [_filteredPeoples count];
    }
    return [_totalPeoples count];
}

//|-------------------------------------------------
//|Inject information of the database in table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellPeople";
    UITableViewCell *cell = [_TableViewPeople dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (!_isFiltered) {
        cell.textLabel.text = [_totalPeoples objectAtIndex:indexPath.row];
    } else { // is Filtered
        cell.textLabel.text = [_filteredPeoples objectAtIndex:indexPath.row];
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
    [singleton setPeople:cellCurrent];
    [singleton setPeopleId:cellCurrentId];
}

//|-------------------------------------------------
//|send people current on people controller and add people on singleton
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [_TableViewPeople indexPathForSelectedRow];
    PessoaController *PC;
    
    //set people current on singleton
    [self sectionCurrent:[_totalPeoples objectAtIndex:path.row]
                      id:[_totalPeoplesId objectAtIndex:path.row]];
    
    //Send to pessoasViewController
    PC = [segue destinationViewController];
}

//|-------------------------------------------------
//|return for pessoas main view controller
- (IBAction)returnPessoaMainViewController:(UIStoryboardSegue*)sender
{
    
}

@end
