//
//  ConfiguracoesController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 29/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "ConfiguracoesController.h"
#import <Parse/Parse.h>

@interface ConfiguracoesController ()

@end

@implementation ConfiguracoesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//|----------------------------------------------
//return start page
-(IBAction)returnConfiguracoesMainViewController:(UIStoryboardSegue *)sender
{
    
}
- (IBAction)ToGoViewSobre:(id)sender {
    [self performSegueWithIdentifier:@"Sobre" sender:self];
}

//|----------------------------------------------
//logout
- (IBAction)logout:(id)sender {

    [self dropSession];
    //redirect
    [self performSegueWithIdentifier:@"LogoutSuccess" sender:self];
}
-(void)dropSession
{
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session removeObjectForKey:@"email"];
    [session removeObjectForKey:@"nome"];
    [session removeObjectForKey:@"objectID"];
    session = nil;
}
- (IBAction)dropAccountConfirm:(id)sender {
    NSLog(@"Apagar conta");
    //popup confirm
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deseja realmente apagar a conta?"
                                                    message:@" "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"Sim",nil];
    [alert show];
    
}
//|-----------------------------------------------
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //get session user
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        //drop data
        PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
        [query whereKey:@"objectId" equalTo:[user objectForKey:@"objectID"]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *result, NSError *error){
            if(!error){
                [result removeObjectForKey:@"senha"];
                [result saveInBackground];
                
                [self dropSession];
                //redirect user
                [self performSegueWithIdentifier:@"LogoutSuccess" sender:self];
            }
        }];
    }
    
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
