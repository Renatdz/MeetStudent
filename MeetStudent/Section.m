//
//  DataBase.m
//  MeetStudent
//
//  Created by Renato Mendes on 23/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import "Section.h"
#import <Parse/Parse.h>

@implementation Section

+ (Section *) section{
    static Section *sectionCurrent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionCurrent = [[self alloc] init];
    });
    return sectionCurrent;
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
