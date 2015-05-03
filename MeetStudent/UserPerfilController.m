//
//  UserPerfilController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 02/05/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "UserPerfilController.h"
#import <Parse/Parse.h>

@interface UserPerfilController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextField *idade;
@property (weak, nonatomic) IBOutlet UITextField *sexo;
@property (weak, nonatomic) IBOutlet UITextField *social;
@property (weak, nonatomic) IBOutlet UITextView *descricao;
@property (weak, nonatomic) IBOutlet UINavigationItem *NameUser;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation UserPerfilController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataUser];
    
    //item selecionado na tabBar
    [self.tabBarController.tabBar.selectedItem setSelectedImage:[UIImage imageNamed:@"profile.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//|------------------------------------------
//Busca as informações do usuário logado
-(void)getDataUser
{
NSUserDefaults *section = [NSUserDefaults standardUserDefaults];
    
    PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
    [query getObjectInBackgroundWithId:[section objectForKey:@"objectID"] block:^(PFObject *user, NSError *error) {
        if(!error){
            NSString *name  = user[@"nome"];
            name = [name capitalizedString];
            name = [name stringByAppendingString:@" "];
            NSString *sobrenome = user[@"sobrenome"];
            sobrenome = [sobrenome capitalizedString];
            name = [name stringByAppendingString:sobrenome];
            _NameUser.title = name;//define title nav bar
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
