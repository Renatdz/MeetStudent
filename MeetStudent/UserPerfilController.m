//
//  UserPerfilController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 02/05/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "UserPerfilController.h"
#import <Parse/Parse.h>

@interface UserPerfilController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextField *idade;
@property (weak, nonatomic) IBOutlet UITextField *sexo;
@property (weak, nonatomic) IBOutlet UITextField *social;
@property (weak, nonatomic) IBOutlet UITextView *descricao;
@property (weak, nonatomic) IBOutlet UINavigationItem *NameUser;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancelEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navEdit;
@property (weak, nonatomic) IBOutlet UIButton *editImg;

@end

@implementation UserPerfilController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataUser];
    [self defaultConstrants];
    
    //set scroll view drag hide keyboard
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //item selecionado na tabBar
    [self.tabBarController.tabBar.selectedItem setSelectedImage:[UIImage imageNamed:@"profile.png"]];
    
    //hiden btn edit
    self.buttonEdit.hidden = YES;
    self.buttonCancelEdit.hidden = YES;
    self.editImg.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)navigationEdit:(id)sender {
    
    //desabilita navigation button edit
    _navEdit.enabled = NO;
    
    //habilita textFields para edição
    _sexo.enabled = YES;
    [self.sexo becomeFirstResponder];
    _sexo.delegate = self;
    _idade.enabled = YES;
    _idade.keyboardType = UIKeyboardTypeNumberPad;
    _idade.delegate = self;
    _social.enabled = YES;
    _social.delegate = self;
    _descricao.editable = YES;
    
    //set visible button update
    _buttonEdit.hidden = NO;
    _buttonCancelEdit.hidden = NO;
    _editImg.hidden = NO;
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

//|------------------------------------------
//Busca as informações do usuário logado
-(void)getDataUser
{
    [self popupLoading:@"Estamos buscando os dados..."];
    
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
- (IBAction)updateData:(id)sender {
    if([self validate]){
        
        [self popupLoading:@"Estamos atualizando os dados..."];
        
        NSUserDefaults *section = [NSUserDefaults standardUserDefaults];
        PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
        [query getObjectInBackgroundWithId:[section objectForKey:@"objectID"] block:^(PFObject *user, NSError *error){
            
            user[@"idade"] = _idade.text;
            user[@"url_social"] = _social.text;
            //image
            CGSize size = CGSizeMake(375.0, 225.0);
            NSData *imageData = UIImagePNGRepresentation([self imageWithImage:_img.image convertToSize:size]);
            //icon
            CGSize sizeIcon = CGSizeMake(60.0, 60.0);
            NSData *dataIcon = UIImagePNGRepresentation([self imageWithImage:_img.image convertToSize:sizeIcon]);
            
            PFFile *imageFile = [PFFile fileWithName:@"img.png" data:imageData];
            PFFile *imageIcon = [PFFile fileWithName:@"icon.png" data:dataIcon];
            user[@"imagem"] = imageFile;
            user[@"icon"] = imageIcon;
            user[@"descricao"] = _descricao.text;
            user[@"sexo"] = _sexo.text;
            
            //save data
            [user saveInBackgroundWithBlock:^(BOOL success, NSError *error){
                if(success){
                    [self disabledEdit];
                    [self getDataUser];
                    
                    [self messagePopup:@"Informações atualizadas com sucesso!"];
                }
            }];
        }];
    }
}
- (IBAction)cancelEdit:(id)sender {
    //cancela ediação
    [self disabledEdit];
    //restart data
    [self getDataUser];
}
-(void)disabledEdit
{
    //habilita navigation button edit
    _navEdit.enabled = YES;
    
    //desabilita textFields para edição
    _sexo.enabled = NO;
    _idade.enabled = NO;
    _social.enabled = NO;
    _descricao.editable = NO;
    
    //set visible button update
    _buttonEdit.hidden = YES;
    _buttonCancelEdit.hidden = YES;
    _editImg.hidden = YES;
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
            [popover presentPopoverFromRect:_img.bounds inView:_img permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    _img.image = image;
    
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

//|-------------------------------------------------
//|Validação das informaçoes submetidas
-(bool)validate
{
    NSString *idad = _idade.text;
    if( (idad != nil) && (([idad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
    }else{
        [self messagePopup:@"Idade não pode estar vazio!"];
        
        //return status false
        return 0;
    }
    NSString *sex = _sexo.text;
    if( (sex != nil) && (([sex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        
    }else{
        [self messagePopup:@"Gênero não pode estar vazio!"];
        //return status false
        return 0;
    }
   
    
    NSString *desc = _descricao.text;
    if( (desc != nil) && (([desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
    }else{
        [self messagePopup:@"Descrição não pode estar vazia!"];
        //return status false
        return 0;
    }
    
    //return status success
    return 1;
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
