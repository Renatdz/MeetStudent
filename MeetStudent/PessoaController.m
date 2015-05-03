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
    NSString *objectId = self.singleton.peopleId;
    NSLog(@"%@", objectId);
    
    PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *user, NSError *error) {
        if(!error){
            
            _idade.text = user[@"idade"];
            _sexo.text = [user[@"sexo"] capitalizedString];
            _social.text = user[@"url_social"];
            _email.text = user[@"email"];
            _descricao.text = [user[@"descricao"] capitalizedString];
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

@end
