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

    //item selecionado na tabBar
    [self.tabBarController.tabBar.selectedItem setSelectedImage:[UIImage imageNamed:@"config.png"]];
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
    [self msgAlert:@"Ao voltar ao aplicativo, informe seus dados acesso!" NSString:@"Bye! :/"];
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

-(void)msgAlert:(NSString *)msg NSString:(NSString *) status
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:status
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
