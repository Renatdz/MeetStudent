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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iGroup;

@property (nonatomic) Section *singleton;

@end

@implementation PessoasController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataGroups];
    
    //define title NavigationItem
    self.singleton = [Section section];
    self.navigationItem.title = self.singleton.group;
    
    self.SearchBarPeople.delegate   = self;
    self.TableViewPeople.delegate   = self;
    self.TableViewPeople.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//|------------------------------------------------
//Vincular-se ao grupo (singleton.groupId;)
- (IBAction)iAddGroup:(id)sender {

    NSUserDefaults *userLogado = [NSUserDefaults standardUserDefaults];
    NSString *objectId = [userLogado objectForKey:@"objectID"];
    
    if([self isVinculo:objectId]){
        
        PFObject *object = [PFObject objectWithClassName:@"it_group_users"];
        object[@"pk_usuario"] = objectId;
        object[@"pk_grupo"] = self.singleton.groupId;
        
        [object saveInBackgroundWithBlock:^(BOOL success, NSError *error){
            if(!error){
                [self msgAlert:@"Você foi adicionado ao grupo " NSString:@"Sucesso :D"];
            }else{
                [self msgAlert:@"Ocorreu um erro inesperado ao tentar vincular sua pessoa ao grupo " NSString:@"Ops :/"];
            }
        }];
    }else
        [self msgAlert:@"Você já está vinculado ao grupo " NSString:@"Ops :/"];
}
-(bool)isVinculo: (NSString *)objectId
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"it_group_users"];
    [query whereKey:@"pk_usuario" equalTo:objectId];
    [query whereKey:@"pk_grupo" equalTo:self.singleton.groupId];
    NSArray *result = [query findObjects];

    return ([result count] > 0 ) ? 0 : 1;
}
-(void)msgAlert:(NSString *)msg NSString:(NSString *) status
{
    NSString *group = @"\"";
    group = [group stringByAppendingString:self.singleton.group];
    group = [group stringByAppendingString:@"\"!"];
    msg = [msg stringByAppendingString:group];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:status
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
    _totalPeoplesImg = [[NSMutableArray alloc] init];
    
    NSArray *result2 = [query2 findObjects];
    
    for (PFObject *people in result2)
    {
        NSString *name  = people[@"nome"];
        name = [name capitalizedString];
        name = [name stringByAppendingString:@" "];
        NSString *sobrenome = people[@"sobrenome"];
        sobrenome = [sobrenome capitalizedString];
        name = [name stringByAppendingString:sobrenome];
        
        PFFile *file = people[@"icon"];
        
        [_totalPeoples addObject:name];
        [_totalPeoplesId addObject:[people objectId]];
        [_totalPeoplesImg addObject:file];
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
        
        _filteredPeoples   = [[NSMutableArray alloc]init];
        _filteredPeoplesId = [[NSMutableArray alloc]init];
        _filteredPeoplesImg = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_totalPeoples count]; i++) {
            NSRange stringRange = [_totalPeoples[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange.location != NSNotFound) {
                [_filteredPeoples addObject:_totalPeoples[i]];
                [_filteredPeoplesId addObject:_totalPeoplesId[i]];
                [_filteredPeoplesImg addObject:_totalPeoplesImg[i]];
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
        
                PFFile *file = [_totalPeoplesImg objectAtIndex:indexPath.row];
                NSData *imageData = [file getData];
                UIImage *image = [UIImage imageWithData:imageData];
                cell.imageView.layer.cornerRadius = 20.0;
                cell.imageView.clipsToBounds = YES;
                cell.imageView.layer.masksToBounds = YES;
                cell.imageView.image = image;
        
    } else { // is Filtered
        cell.textLabel.text = [_filteredPeoples objectAtIndex:indexPath.row];
        PFFile *file = [_filteredPeoplesImg objectAtIndex:indexPath.row];
        NSData *imageData = [file getData];
        UIImage *image = [UIImage imageWithData:imageData];
        //set border radius
        cell.imageView.layer.cornerRadius = 20.0;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.image = image;
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
    
    if (_isFiltered) {
        //set people current on singleton
        [self sectionCurrent:[_filteredPeoples objectAtIndex:path.row]
                          id:[_filteredPeoplesId objectAtIndex:path.row]];
    }else{
        //set people current on singleton
        [self sectionCurrent:[_totalPeoples objectAtIndex:path.row]
                          id:[_totalPeoplesId objectAtIndex:path.row]];
    }
    //Send to pessoasViewController
    PessoaController *PC = [segue destinationViewController];
    NSLog(@"pc -> %@", PC);
}

//|-------------------------------------------------
//|return for pessoas main view controller
- (IBAction)returnPessoaMainViewController:(UIStoryboardSegue*)sender
{
}

@end
