//
//  CLQTokenCard.m
//  payments
//
//  Created by William Muro on 9/11/16.
//  Copyright © 2016 May. All rights reserved.
//

#import "CLQTokenCard.h"

@implementation CLQTokenCard

#pragma mark - Lifecycle

- (instancetype)initWithBrand:(NSString *)brand number:(NSString *)number bin:(NSString *)bin type:(NSString *)type category:(NSString *)category{
    
    self = [super init];
    if (self) {
        _brand = brand;
        _number = number;
        _bin = bin;
        _type = type;
        _category = category;

    }
    return self;
}

+ (instancetype)newWithBrand:(NSString *)brand number:(NSString *)number bin:(NSString *)bin type:(NSString *)type category:(NSString *)category{
    
    return [[CLQTokenCard alloc] initWithBrand:brand
                                        number:number
                                           bin:bin
                                          type:type
                                      category:category];
}

@end
