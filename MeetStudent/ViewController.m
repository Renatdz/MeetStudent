//
//  ViewController.m
//  MeetStudent
//
//  Created by Renato Mendes on 23/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "ViewController.h"
#import "InstituicoesController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCadastro;
@property (weak, nonatomic) IBOutlet UIButton *politicaDePrivacidade;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//|---------------------------------------
- (IBAction)politicaPrivacidade:(id)sender {
    //redirect view politica de privacidade
    [self performSegueWithIdentifier:@"PoliticaDePrivacidade" sender:self];
}

//|-------------------------------------------------
//|return for view controller
- (IBAction)returnMainViewController:(UIStoryboardSegue*)sender
{

}
- (IBAction)cadastrar:(id)sender {
    
    //popup confirm
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
                                                    message:@"Ao clicar em `Concordar` você concorda com nossa Política de Privacidade!\nCaso ainda não tenha lido, por favor leia."
                                                   delegate:self
                                          cancelButtonTitle:@"Ler"
                                          otherButtonTitles:@"Concordar",nil];
    [alert show];
}
//|-----------------------------------------------
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //redirect view cadastro
        [self performSegueWithIdentifier:@"Cadastrar" sender:self];
    }else{
        //redirect view politica de privacidade
        [self performSegueWithIdentifier:@"PoliticaDePrivacidade" sender:self];
    }
    
}


@end
