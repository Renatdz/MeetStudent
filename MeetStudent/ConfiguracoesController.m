//
//  ConfiguracoesController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 29/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "ConfiguracoesController.h"

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
