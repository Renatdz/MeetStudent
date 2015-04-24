//
//  CadastroController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 24/04/15.
//  Updated by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "CadastroController.h"
#import "DataBase.h"

@interface CadastroController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImageView *imagemPadrao; //imagem padrão a ser usada caso o usuário não defina uma.
}


@end

@implementation CadastroController

//|----------------------------------------------
//|Sera executado quando a view for aparecer (carregada)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultValues];
    
}

//|----------------------------------------------
//|Sera executado quando a view for desaparecer (descarregada)
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Referencia o Singleton
    //DataBase *singleton = [DataBase dataBase];
    
    // Salva as informacoes do usuario no Singleton
    //[singleton variavel = @""];
}

//|----------------------------------------------
//| Define os valores/propriedades padrões
-(void)defaultValues
{
    //set radius image
    _image.layer.cornerRadius = CGRectGetHeight(_image.bounds) / 2.0;
    _image.clipsToBounds = YES;
    
    // Carrega a imagem padrao para adicao de foto
    //_image.image = [UIImage imageNamed:@"nome da imagem"];
    //imagemPadrao = _image;

    
    //set keyboar type number
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

//|-------------------------------------------------
//|Aciona a câmera e tira foto para a imagem de perfil
- (void)takePicture
{
    // Inicializa um imagePickerController
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Verifica se o device possui uma camera, caso contrario ira a penas carregar a biblioteca de fotos
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    // Delega ao controlador
    imagePicker.delegate = self;
    
    // Comportamento diferente do imagePicker caso o device seja um iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Utilizar o popOver
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        // Adiciona a operacao do popover para a fila de Operacoes
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [popover presentPopoverFromRect:_image.bounds inView:_image permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popOver = popover;
        }];
        
    } else {
        // Caso seja iphone, apresentar o imagePicker normalmente
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//|-------------------------------------------------
//|Pega a imagem da biblioteca ou da câmera e seta ela na imageView da view.
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Recebe a imagem escolhida do dicionario info
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // Seta a imagem escolhida na nossa view profileImage
    _image.image = image;
    
    // Retira o imagePicker da tela
    [self dismissViewControllerAnimated:YES completion:nil];
}

//|-------------------------------------------------
//|Chama a aplicacao da biblioteca de fotos (nativa)
-(void)choosePicture
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Seta como o tipo do imagePicker sendo a biblioteca de fotos
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Delega ao controlador e retira o imagePicker da tela
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//|-------------------------------------------------
//|Menu de escolha entre camera e biblioteca de fotos
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Troca entre os estilos da navigation bar
        switch (buttonIndex)
        {
            case 0: // Camera
                [self takePicture];
                break;
            case 1: // Biblioteca de fotos
                [self choosePicture];
                break;
        }
        // just add picker code here and it will work fine.
        
        
        // Ask the system to re-query our -preferredStatusBarStyle.
        // Pede ao sistema para atualizar o status da navBar
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

//|-------------------------------------------------
//|Inicializa actionSheet (menu de escolhas) e seta seus valores.
- (IBAction)optionBar:(id)sender
{
    // Inicializa a navBar
    UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"Tirar Foto", @""),
                                 NSLocalizedString(@"Escolher Foto", @""),
                                 nil];
    
    // Seta o mesmo estilo (navigationBar)
    styleAlert.actionSheetStyle = (UIActionSheetStyle)self.navigationController.navigationBar.barStyle;
    
    // Mostra o navBar na self.view
    [styleAlert showInView:self.view];
}

@end
