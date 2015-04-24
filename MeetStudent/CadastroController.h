//
//  CadastroController.h
//  MeetStudent
//
//  Created by Rafael Cabral on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CadastroController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *sobrenome;
@property (weak, nonatomic) IBOutlet UITextField *idade;
@property (weak, nonatomic) IBOutlet UITextField *sexo;
@property (weak, nonatomic) IBOutlet UITextField *urlSocial;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *senha;
@property (weak, nonatomic) IBOutlet UITextField *confSenha;
@property (weak, nonatomic) IBOutlet UITextView *descricao;


@end
