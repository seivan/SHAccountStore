//
//  SHAccountCredential.m
//  SHAccountManagerExample
//
//  Created by Seivan Heidari on 3/20/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAccountCredential.h"

@interface SHAccountCredential ()
@property(copy, NS_NONATOMIC_IOSONLY) NSString * token;
@property(copy, NS_NONATOMIC_IOSONLY) NSString * secret;
@property(copy, NS_NONATOMIC_IOSONLY) NSString * refreshToken;
@property(copy, NS_NONATOMIC_IOSONLY) NSDate   * expiryDate;
@end

@implementation SHAccountCredential
- (id)initWithOAuthToken:(NSString *)token tokenSecret:(NSString *)secret; {
  NSAssert(token, @"Must pass token");
  NSAssert(token, @"Must pass secret");
  self = [self init];
  if (self) {
    self.token = token;
    self.secret = secret;
  }
  return self;
}

- (id)initWithOAuth2Token:(NSString *)token
             refreshToken:(NSString *)refreshToken
               expiryDate:(NSDate *)expiryDate; {
  NSAssert(token, @"Must pass token");
  NSAssert(token, @"Must pass refreshToken");
  
  self = [self init];
  if (self) {
    self.token = token;
    self.refreshToken = refreshToken;
    self.expiryDate = expiryDate;
  }
  return self;

}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.token forKey:@"credential.token"];
  [coder encodeObject:self.secret forKey:@"credential.secret"];
  [coder encodeObject:self.refreshToken forKey:@"credential.refreshToken"];
  [coder encodeObject:self.expiryDate forKey:@"credential.expiryDate"];
  [coder encodeObject:self.oauthToken forKey:@"credential.oauthToken"];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if(self) {
    self.token        = [coder decodeObjectForKey:@"credential.token"];
    self.secret         = [coder decodeObjectForKey:@"credential.secret"];
    self.refreshToken     = [coder decodeObjectForKey:@"credential.refreshToken"];
    self.expiryDate     = [coder decodeObjectForKey:@"credential.expiryDate"];
    self.oauthToken = [coder decodeObjectForKey:@"credential.oauthToken"];
  }
  return self;
}


@end
