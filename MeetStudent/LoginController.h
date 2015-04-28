//
//  LoginController.h
//  MeetStudent
//
//  Created by Rafael Cabral on 28/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usuario;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
