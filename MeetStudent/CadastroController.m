//
//  CadastroController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "CadastroController.h"

@interface CadastroController ()

@end

@implementation CadastroController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultValues];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//|----------------------------------------------
//| Define os valores/propriedades padrões
-(void)defaultValues
{
    _idade.keyboardType = UIKeyboardTypeNumberPad;
    _senha.secureTextEntry = YES;
    _confSenha.secureTextEntry = YES;
    //set border and radius
    self.nome.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _nome.layer.borderWidth = 1.0;
    _nome.layer.cornerRadius = 5.0;
    _sobrenome.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _sobrenome.layer.borderWidth = 1.0;
    _sobrenome.layer.cornerRadius = 5.0;
    _idade.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _idade.layer.borderWidth = 1.0;
    _idade.layer.cornerRadius = 5.0;
    _sexo.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _sexo.layer.borderWidth = 1.0;
    _sexo.layer.cornerRadius = 5.0;
    _email.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _urlSocial.layer.borderWidth = 1.0;
    _urlSocial.layer.cornerRadius = 5.0;
    _urlSocial.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _email.layer.borderWidth = 1.0;
    _email.layer.cornerRadius = 5.0;
    _senha.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _senha.layer.borderWidth = 1.0;
    _senha.layer.cornerRadius = 5.0;
    _confSenha.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _confSenha.layer.borderWidth = 1.0;
    _confSenha.layer.cornerRadius = 5.0;
    _descricao.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    _descricao.layer.borderWidth = 1.0;
    _descricao.layer.cornerRadius = 5.0;
    
}

//|-----------------------------------------------
//| Envio de dados
- (IBAction)enviarDados:(id)sender {
    
    //validate
    if([self validate]){
        NSLog(@"Informações válidas %d", [self validate]);
        //redirect
        [self performSegueWithIdentifier:@"CadastroSuccess" sender:self];
    }else{
        NSLog(@"Informações não válidas");
    }
    
}
//|-------------------------------------------------
//|Validação das informaçoes submetidas
-(bool)validate
{
    NSString *name = _nome.text;

    if( (name != nil) && (([name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        self.nome.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        self.nome.layer.borderColor = [[UIColor redColor] CGColor];
        
        return 0;
    }
    NSString *sNome = _sobrenome.text;
    if( (sNome != nil) && (([sNome stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        _sobrenome.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        _sobrenome.layer.borderColor = [[UIColor redColor] CGColor];
        
        //return status false
        return 0;
    }
    
    NSString *idad = _idade.text;
    if( (idad != nil) && (([idad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        _idade.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/

    }else{
        _idade.layer.borderColor = [[UIColor redColor] CGColor];

        //return status false
        return 0;
    }
    NSString *sex = _sexo.text;
    if( (sex != nil) && (([sex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        _sexo.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
        
    }else{
        _sexo.layer.borderColor = [[UIColor redColor] CGColor];
        
        //return status false
        return 0;
    }
    NSString *mail = _email.text;
    if( (mail != nil) && (([mail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        _email.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        _email.layer.borderColor = [[UIColor redColor] CGColor];
        //return status false
        return 0;
    }
    NSString *pass = _senha.text;
    NSString *confPass = _confSenha.text;
    if( ((pass != nil) && (([pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)) && ((confPass != nil) && (([confPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)) ){
        
        if([_senha.text isEqualToString:_confSenha.text])
        {
            _senha.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
            _confSenha.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
            _senha.layer.borderWidth = 1.0;
            _senha.layer.cornerRadius = 5.0;
            _confSenha.layer.borderWidth = 1.0;
            _confSenha.layer.cornerRadius = 5.0;
        }else{
            _senha.layer.borderColor = [[UIColor redColor] CGColor];
            _confSenha.layer.borderColor = [[UIColor redColor] CGColor];
            _confSenha.text = @"";
            //return status false
            return 0;
        }
    }else{
            _senha.layer.borderColor = [[UIColor redColor] CGColor];
            _confSenha.layer.borderColor = [[UIColor redColor] CGColor];
        //return status false
        return 0;

    }
    
    NSString *desc = _descricao.text;
    if( (desc != nil) && (([desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        _descricao.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        _descricao.layer.borderColor = [[UIColor redColor] CGColor];
        _descricao.text = @"Eu sou uma pessoa...";
        //return status false
        return 0;
    }
    
    //return status success
    return 1;
}


@end
