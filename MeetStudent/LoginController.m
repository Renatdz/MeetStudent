//
//  LoginController.m
//  MeetStudent
//
//  Created by Rafael Cabral on 28/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "LoginController.h"
#import <CommonCrypto/CommonDigest.h>
#import <Parse/Parse.h>

@interface LoginController ()


@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set defaults
    [self genericValues:_usuario];
    [self genericValues:_password];
    _password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logar:(id)sender {
    if([self validate]){
        
        //message loading
        [self popupLoading];
        
        PFQuery *query = [PFQuery queryWithClassName:@"usuarios"];
        [query whereKey:@"email" equalTo:_usuario.text];
        [query whereKey:@"senha" equalTo:[self encryptPassword:_password.text]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && ([objects count] > 0) ) {
                NSString *nome  = [objects[0] objectForKey:@"nome"];
                NSString *email = [objects[0] objectForKey:@"email"];
                NSString *idUser = [objects[0] objectId];
               
                NSUserDefaults *section = [NSUserDefaults standardUserDefaults];
                    
                    //set section on userDefaults
                    [section setObject:nome forKey:@"nome"];
                    [section setObject:email forKey:@"email"];
                    [section setObject:idUser forKey:@"objectID"];
                    
                    [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
                
            }else{
                [self alertView];
            }
        }];
        
    }else{
        NSLog(@"Informações não válidas");
    }
    
}
//|----------------------------------------------
//Alert data invalid
-(void) alertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção, os dados informados não são válidos!"
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
    data.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    data.layer.borderWidth = 1.0;
    data.layer.cornerRadius = 5.0;
    data.returnKeyType = UIReturnKeyDone;
    data.delegate = self;
}
//|-------------------------------------------------
//|Validação das informaçoes submetidas
-(bool)validate
{
    NSString *usuario = _usuario.text;
    if( (usuario != nil) && (([usuario stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        self.usuario.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        self.usuario.layer.borderColor = [[UIColor redColor] CGColor];
        
        return 0;
    }
    NSString *pass = _password.text;
    if( (pass != nil) && (([pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]).length > 0)){
        self.password.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor]; /*#cccccc*/
    }else{
        self.password.layer.borderColor = [[UIColor redColor] CGColor];
        
        return 0;
    }
    return 1;
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
