//
//  GrupoController.m
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "GrupoController.h"
#import <Parse/Parse.h>
#import "Section.h"

@interface GrupoController ()

@end

@implementation GrupoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self genericValues:_nomeNovoGrupo];
}

//|-----------------------------------------------
//|Envio para a tabela o novo grupo
- (IBAction)creatingGroup:(id)sender {
    NSLog(@"creatingGroup");
    if([self validate]){
        if([self isDuplicateGroup]){
            //msg popup
            [self popupLoading:@"Estamos cadastrando os dados..."];
            
            //get singleton
            Section *singleton = [Section section];
            
            //define table database
            PFObject *grupo = [PFObject objectWithClassName:@"grupo"];
            grupo[@"nome"] = _nomeNovoGrupo.text;
            grupo[@"pk_instituicao"] = singleton.instituitionId;
            
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            grupo[@"pk_usuario"] = [session objectForKey:@"objectID"];
            //save data grupo
            [grupo saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if(success){
                    NSLog(@"sucesso");
                    //define table database relations
                    PFObject *relations = [PFObject objectWithClassName:@"it_group_users"];
                    relations[@"pk_usuario"] = [session objectForKey:@"objectID"];
                    relations[@"pk_grupo"] = [grupo objectId];
                    //save data
                    [relations saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                        if(success){
                            [self messagePopup:@"Grupo criado com sucesso!"];
                            [self performSegueWithIdentifier:@"CreateGroup" sender:self];
                        }else{
                            [self messagePopup:@"Ops :/ \n Algo deu errado, por favor tente novamente"];
                        }
                    }];
                }else{
                    [self messagePopup:@"Ops :/ \n Algo deu errado, por favor tente novamente"];
                }
            }];
        }
    }
}
//|----------------------------------------------
//valid data
-(bool)validate
{
    NSString *group = _nomeNovoGrupo.text;
    if( (group != nil) && (([group stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        self.nomeNovoGrupo.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        self.nomeNovoGrupo.layer.borderColor = [[UIColor redColor] CGColor];
        
        return 0;
    }
    return 1;
}
//|-------------------------------------------------
//valid duplicidade de grupo
-(bool)isDuplicateGroup
{
    PFQuery *query = [PFQuery queryWithClassName:@"grupo"];
    [query whereKey:@"nome" equalTo:_nomeNovoGrupo.text];
    NSArray *result = [query findObjects];
    if([result count] > 0){
        _nomeNovoGrupo.layer.borderColor = [[UIColor redColor] CGColor];
        
        [self messagePopup:@"Atenção, este grupo já existe no sistema!"];
        return 0;
    }else{
        _nomeNovoGrupo.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
        return 1;
    }
}
//|-------------------------------------------------
//Ocultar teclado
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view]endEditing:YES];
}
//|----------------------------------------------
//return keyboard to textField
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

//|-------------------------------------------------
//show message popup
-(void)messagePopup:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//|----------------------------------------------
//set generic defaults
-(void) genericValues:(UITextField *) data
{
    //foco in textField
    [data becomeFirstResponder];
    
    data.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    data.layer.borderWidth = 1.0;
    data.layer.cornerRadius = 5.0;
    data.returnKeyType = UIReturnKeyDone;
    data.delegate = self;
}

//|--------------------------------------
//Message de loading
//Informa o usuário que o app esta processando a requisição
-(void) popupLoading: (NSString *) msg
{
    UIAlertView *alert;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Por favor aguarde!" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
@end
