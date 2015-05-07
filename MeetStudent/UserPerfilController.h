//
//  UserPerfilController.h
//  MeetStudent
//
//  Created by Rafael Cabral on 02/05/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPerfilController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) UIPopoverController  *popOver; // Controlador do popOver (iPad)

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
