//
//  PessoaController.m
//  MeetStudent
//
//  Created by Renato Mendes on 03/05/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "PessoaController.h"
#import "Section.h"
#import <Parse/Parse.h>

@interface PessoaController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextField *sexo;
@property (weak, nonatomic) IBOutlet UITextField *idade;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *social;
@property (weak, nonatomic) IBOutlet UITextView *descricao;
@property (nonatomic) Section *singleton;

@end

@implementation PessoaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //define NavigationItem
    self.singleton = [Section section];
    self.navigationItem.title = self.singleton.people;
    

    [self getDataUser];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//|------------------------------------------
//Busca as informações do usuário logado
-(void)getDataUser
{
    [self popupLoading];
    
    NSString *objectId = self.singleton.peopleId;
    PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *user, NSError *error) {
        if(!error){
            
            _idade.text = user[@"idade"];
            _sexo.text = [user[@"sexo"] capitalizedString];
            _social.text = user[@"url_social"];
            _email.text = user[@"email"];
            _descricao.text = user[@"descricao"];
            //set img
            PFFile *file = user[@"imagem"];
            [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    _img.image = image;
                }
            }];
            
        }
    }];
}

//|--------------------------------------
//Message de loading
//Informa o usuário que o app esta processando a requisição
-(void) popupLoading
{
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Por favor aguarde!" message:@"Estamos buscando os dados..." delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


@end
