//
//  InstituicoesController.m
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "InstituicoesController.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>
#import "Section.h"
#import "GruposController.h"

@interface InstituicoesController ()

@end

@implementation InstituicoesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataGroups];
    //item selecionado na tabBar
    [self.tabBarController.tabBar.selectedItem setSelectedImage:[UIImage imageNamed:@"instituicao.png"]];
    
    self.TableViewInstitution.delegate   = self;
    self.TableViewInstitution.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//|-------------------------------------------------
//|Return information of the database
- (void)loadDataGroups
{
    //instituicao
    PFQuery *query = [PFQuery queryWithClassName:@"instituicao"];
    
    _totalIdsInstituition = [[NSMutableArray alloc]init];
    _totalInstitution     = [[NSMutableArray alloc]init];
    _totalSubtitle        = [[NSMutableArray alloc]init];
    
    NSArray *result = [query findObjects];
    
    for (PFObject *instituition in result){
        [_totalIdsInstituition addObject:[instituition objectId]];
        [_totalInstitution addObject:instituition[@"instituicao"]];
        [_totalSubtitle addObject:instituition[@"subtitulo"]];
    }
}

#pragma mark - Table view data source

//|-------------------------------------------------
//|Return number of sections on table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//|-------------------------------------------------
//|Return number of rows of table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_totalInstitution count];
}

//|-------------------------------------------------
//|Inject information of the database in table cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellInstituition";
    
    UITableViewCell *cell = [_TableViewInstitution dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text       = [_totalInstitution objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_totalSubtitle objectAtIndex:indexPath.row];
    
    return cell;
}

//|-------------------------------------------------
//|Add section of Instituition current
- (void)sectionCurrent:(NSString *)cellCurrent id:(NSString *)cellCurrentId
{
    //alloc singleton
    Section *singleton = [Section section];
    
    //set instituition current
    [singleton setInstituition:cellCurrent];
    [singleton setInstituitionId:cellCurrentId];
}

//|-------------------------------------------------
//|send instituition current on groups controller and add instituition on singleton
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.TableViewInstitution indexPathForSelectedRow];
    GruposController *GC;
    
    //set instituition current on singleton
    [self sectionCurrent:[_totalInstitution objectAtIndex:path.row]
                      id:[_totalIdsInstituition objectAtIndex:path.row]];
    
    //Send to gruposViewController
    GC = [segue destinationViewController];
}

//|-------------------------------------------------
//|return for table main view controller
- (IBAction)returnTableMainViewController:(UIStoryboardSegue*)sender
{
    
}

@end
