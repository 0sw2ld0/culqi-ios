//
//  CLQToken.h
//  payments
//
//  Created by William Muro on 9/11/16.
//  Copyright © 2016 May. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLQTokenCard;

NS_ASSUME_NONNULL_BEGIN
@interface CLQToken : NSObject

@property (nonatomic, readonly) NSString * email;
@property (nonatomic, readonly) NSString * objectType;
@property (nonatomic, readonly) NSString * identifier;
@property (nonatomic, readonly) NSString * createdAt;

@property (nonatomic, strong, readonly) CLQTokenCard * tokenCard;

- (instancetype)initWithIdentifier:(NSString *)identifier
                                     email:(NSString *)email
                                 createdAt:(NSString *)createdAt
                                objectType:(NSString *)objectType
                                 tokenCard:(CLQTokenCard *)tokenCard;

+ (instancetype)newWithIdentifier:(NSString *)identifier
                                    email:(NSString *)email
                                createdAt:(NSString *)createdAt
                               objectType:(NSString *)objectType
                                tokenCard:(CLQTokenCard *)tokenCard;

@end
NS_ASSUME_NONNULL_END
