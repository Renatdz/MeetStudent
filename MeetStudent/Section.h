//
//  DataBase.h
//  MeetStudent
//
//  Created by Renato Mendes on 23/04/15.
//  Copyright (c) 2015 RR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject{
    
}

@property (nonatomic, retain) NSString *instituition;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *people;

+(Section *)section;
-(void)clean;

@end

