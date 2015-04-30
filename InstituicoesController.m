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

@interface InstituicoesController ()
{
    NSMutableArray *totalInstitution;
    NSMutableArray *totalSubtitle;
}

@end

@implementation InstituicoesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataGroups];
    
    self.TableViewInstitution.delegate   = self;
    self.TableViewInstitution.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//|-------------------------------------------------
//|Return information of the database
- (void)loadDataGroups
{
    //instituicao
    PFQuery *query = [PFQuery queryWithClassName:@"instituicao"];
    
    totalInstitution = [[NSMutableArray alloc]init];
    totalSubtitle    = [[NSMutableArray alloc]init];
    NSArray *result = [query findObjects];
    
    for (PFObject *instituition in result){
        [totalInstitution addObject:instituition[@"instituicao"]];
        [totalSubtitle addObject:instituition[@"subtitulo"]];
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
    return [totalInstitution count];
}

//|-------------------------------------------------
//|Inject information of the database in table cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text       = [totalInstitution objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [totalSubtitle objectAtIndex:indexPath.row];
    
    return cell;
}

//|-------------------------------------------------
//|return for table main view controller
- (IBAction)returnTableMainViewController:(UIStoryboardSegue*)sender
{
    
}

//|----------------------------------------------
//logout
- (IBAction)logout:(id)sender {
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session removeObjectForKey:@"email"];
    [session removeObjectForKey:@"nome"];
    [session removeObjectForKey:@"objectID"];
    session = nil;
    
    [self performSegueWithIdentifier:@"LogoutSuccess" sender:self];
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
