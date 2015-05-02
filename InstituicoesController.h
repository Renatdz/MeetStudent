//
//  InstituicoesController.h
//  MeetStudent
//
//  Created by Renato Mendes on 24/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstituicoesController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *TableViewInstitution;
@property (nonatomic) NSMutableArray *totalIdsInstituition;
@property (nonatomic) NSMutableArray *totalInstitution;
@property (nonatomic) NSMutableArray *totalSubtitle;

@end
