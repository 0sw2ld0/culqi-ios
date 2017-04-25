//
//  Culqi.m
//  payments
//
//  Created by William Muro on 9/11/16.
//  Copyright © 2016 May. All rights reserved.
//

#import "Culqi.h"

#import "CLQHTTPSessionManager.h"
#import "CLQWebServices.h"
#import "CLQCard.h"
#import "CLQToken.h"
#import "CLQTokenCard.h"

@implementation Culqi

static NSString *CLQCheckoutBaseURLString = @"https://api.culqi.com/v2/";

static Culqi *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return [[Culqi alloc] init];
}

- (id)mutableCopy {
    return [[Culqi alloc] init];
}

- (id) init {
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    if (self) {
        [CLQHTTPSessionManager initWithBaseURLString:CLQCheckoutBaseURLString];
    }
    return self;
}

#pragma mark - Autorization

- (void)setMerchantCode:(NSString *)merchantCode {
    
    [CLQWebServices setAutorizationHeaderFieldWithMerchantCode:merchantCode];
    
    _merchantCode = merchantCode;
}

#pragma mark - Tokenization

- (void)createTokenForCard:(CLQCard *)card success:(void (^)(CLQToken *))success failure:(void (^)(NSError *))failure {
    
    [CLQWebServices createTokenForEmail:card.email CVC:card.cvc expMonth:card.expMonth expYear:card.expYear number:card.number success:^(NSDictionary *responseObject) {
        
        CLQToken *token = [self createTokenFromDictionary:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success(token);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failure) failure(error);
        });
    }];
}

#pragma mark - Object Parsing

- (CLQToken *)createTokenFromDictionary:(NSDictionary *)tokenDictionary {
    
    NSString *identifier = [tokenDictionary objectForKey:@"id"];
    NSString *email = [tokenDictionary objectForKey:@"email"];
    NSString *objectType = [tokenDictionary objectForKey:@"object"];
    // TODO: set createdAt
    
    
    CLQTokenCard *tokenCard = [self createTokenCardFromDictionary:tokenDictionary];

    return [CLQToken newWithIdentifier:identifier email:email createdAt:@"" objectType:objectType tokenCard:tokenCard];
}

- (CLQTokenCard *)createTokenCardFromDictionary:(NSDictionary *)tokenDictionary {
    NSDictionary *iinDictionary = [tokenDictionary objectForKey:@"iin"];

    NSString *brand = [iinDictionary objectForKey:@"card_brand"];
    NSString *number = [tokenDictionary objectForKey:@"card_number"];
    NSString *bin = [iinDictionary objectForKey:@"bin"];
    NSString *type = [iinDictionary objectForKey:@"card_type"];
    NSString *category = [iinDictionary objectForKey:@"card_category"];

    return [CLQTokenCard newWithBrand:brand number:number bin:bin type:type category:category];
}

@end
