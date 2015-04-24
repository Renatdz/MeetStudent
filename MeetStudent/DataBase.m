//
//  DataBase.m
//  MeetStudent
//
//  Created by Renato Mendes on 23/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "DataBase.h"
#import <Parse/Parse.h>

@implementation DataBase

+ (DataBase *) dataBase{
    static DataBase *dataAccess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataAccess = [[self alloc] init];
    });
    return dataAccess;
}

-(void)initia{

}

- (id)init {
    // Valores iniciais deverao estar aqui
    if (self = [super init]) {
        // Instanciando os dicionarios
        [self initia];
    }
    return self;
}

-(void)clean{
    [self initia];
}

@end
