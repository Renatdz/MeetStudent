//
//  InstituicoesController.m
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "InstituicoesController.h"

@interface InstituicoesController ()

@end

@implementation InstituicoesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Test Section
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[user objectForKey:@"nome"]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//|-------------------------------------------------
//|return for table main view controller
- (IBAction)returnTableMainViewController:(UIStoryboardSegue*)sender
{
    
}

//|----------------------------------------------
//logout
- (IBAction)logout:(id)sender {
    NSLog(@"logout");
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session removeObjectForKey:@"email"];
    [session removeObjectForKey:@"nome"];
    session = nil;

    
   // [self performSegueWithIdentifier:@"ViewInit" sender:self];
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
