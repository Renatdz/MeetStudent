//
//  CadastroController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 24/04/15.
//  Updated by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "CadastroController.h"
#import "Section.h"
#import <Parse/Parse.h>
#import <CommonCrypto/CommonDigest.h>

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
    [self defaultConstrants];
    
}

//|----------------------------------------------
//|Sera executado quando a view for desaparecer (descarregada)
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // Referencia o Singleton
    //Section *singleton = [Section section];
    
    // Salva as informacoes do usuario no Singleton
    //[singleton variavel = @""];
}


//|----------------------------------------------
//|Seta os constrants para quando o teclado aparecer.
-(void)defaultConstrants
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//|----------------------------------------------
//| Define os valores/propriedades padrões
-(void)defaultValues
{
    //foco in textField
    [self.nome becomeFirstResponder];
    
    //set radius image
    //_image.layer.cornerRadius = CGRectGetHeight(_image.bounds) / 2.0;
    //_image.clipsToBounds = YES;
    //_image.layer.masksToBounds = YES;
    
    // Carrega a imagem padrao para adicao de foto
    _image.image = [UIImage imageNamed:@"add-photo.png"];
    //imagemPadrao = _image;

    
    //set keyboar type number
    _idade.keyboardType = UIKeyboardTypeNumberPad;
    _senha.secureTextEntry = YES;
    _confSenha.secureTextEntry = YES;
    //set generic border and radius
    [self genericValues:_nome];
    [self genericValues:_sobrenome];
    [self genericValues:_idade];
    [self genericValues:_sexo];
    [self genericValues:_email];
    [self genericValues:_senha];
    [self genericValues:_confSenha];
    [self genericValues:_urlSocial];
    [self genericValueDescription:_descricao];
    
    //set scrollview on view
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 562)];
    //set scroll view drag hide keyboard
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

-(void) genericValues:(UITextField *) textField
{
    textField.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 5.0;
    textField.delegate = self;
}

-(void) genericValueDescription:(UITextView *) textView
{
    textView.delegate = self;
}

//|-------------------------------------------------
//Ocultar teclado
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITextField *textField in [self.contentView subviews]) {
        [textField endEditing:YES];
    }
    
    for (UITextView *textView in [self.contentView subviews]) {
        [textView endEditing:YES];
    }
    
}
//|----------------------------------------------
//return keyboard to textField
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//|-----------------------------------------------
//| Envio de dados
- (IBAction)enviarDados:(id)sender {
    
    //validate
    if([self validate]){
        if([self isDuplicateEmail]){
        
            //msg popup
            [self popupLoading:@"Estamos cadastrando os dados..."];
            
            //define table database
            PFObject *user = [PFObject objectWithClassName:@"usuarios"];
            user[@"nome"] = _nome.text;
            user[@"idade"] = _idade.text;
            user[@"url_social"] = _urlSocial.text;
        
            //image
            CGSize size = CGSizeMake(375.0, 225.0);
            NSData *imageData = UIImagePNGRepresentation([self imageWithImage:_image.image convertToSize:size]);
            //icon
            CGSize sizeIcon = CGSizeMake(45.0, 45.0);
            NSData *dataIcon = UIImagePNGRepresentation([self imageWithImage:_image.image convertToSize:sizeIcon]);
            
            PFFile *imageFile = [PFFile fileWithName:@"img.png" data:imageData];
            PFFile *imageIcon = [PFFile fileWithName:@"icon.png" data:dataIcon];
            user[@"imagem"] = imageFile;
            user[@"icon"] = imageIcon;
            user[@"descricao"] = _descricao.text;
            user[@"sobrenome"] = _sobrenome.text;
            user[@"sexo"] = _sexo.text;
            user[@"email"] = _email.text;
            user[@"senha"] = [self encryptPassword:_senha.text];
        
            [user saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if(success){
                    NSUserDefaults *section = [NSUserDefaults standardUserDefaults];
                    
                    //set section on userDefaults
                    [section setObject:_nome.text forKey:@"nome"];
                    [section setObject:_email.text forKey:@"email"];
                    [section setObject:[user objectId] forKey:@"objectID"];
                    //redirect
                    [self performSegueWithIdentifier:@"CadastroSuccess" sender:self];
                }
            }];
            
        }
    }else{
        NSLog(@"Informações não válidas");
    }
    
}
//|-------------------------------------------------
//valid duplicidade de e-mail
-(bool)isDuplicateEmail
{

    PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
    [query whereKey:@"email" equalTo:_email.text];
    NSArray *result = [query findObjects];
    if([result count] > 0){
        _email.layer.borderColor = [[UIColor redColor] CGColor];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção, o e-mail informado já existe no sistema!"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return 0;
    }else{
        _email.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
        return 1;
    }
}

//|-------------------------------------------------
//|Validação das informaçoes submetidas
-(bool)validate
{
    if(_image.image == nil){
        _image.layer.borderColor = [[UIColor redColor] CGColor];
        return 0;
    }else{
        _image.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }
    
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

//|----------------------------------------
//Encrypt password
-(NSString *)encryptPassword:(NSString *)key
{
    const char *cStr = [key UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    int size =  (int)[key length];
    
    CC_MD5(cStr, size, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
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
//|--------------------------------------
// resize UIImage
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.descricao.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.descricao.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end