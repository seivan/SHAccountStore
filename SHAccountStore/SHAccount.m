//
//  SHAccount.m
//  SHAccountManagerExample
//
//  Created by Seivan Heidari on 3/20/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAccount.h"
#import "SHAccountType.h"
#import "SHAccountCredential.h"

@implementation SHAccount
@synthesize identifier = _identifier;

- (id)initWithAccountType:(SHAccountType *)type; {
  NSAssert(type, @"Must pass SHAccountType");
  self = [self init];
  if (self) {
    self.accountType = type;
  }
  return self;
}

-(void)setIdentifier:(NSString *)identifier; {
  _identifier = identifier;
}


- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.identifier forKey:@"account.identifier"];
  [coder encodeObject:self.accountType forKey:@"account.accountType"];
  [coder encodeObject:self.accountDescription forKey:@"account.accountDescription"];
  [coder encodeObject:self.username forKey:@"account.username"];
  [coder encodeObject:self.credential forKey:@"account.credential"];
}



- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if(self) {
    self.identifier         = [coder decodeObjectForKey:@"account.identifier"];
    self.accountType        = [coder decodeObjectForKey:@"account.accountType"];
    self.accountDescription = [coder decodeObjectForKey:@"account.accountDescription"];
    self.username           = [coder decodeObjectForKey:@"account.username"];
    self.credential         = [coder decodeObjectForKey:@"account.credential"];
  }
  return self;
}
-(id)copyWithZone:(NSZone *)zone; {
  SHAccount *copy = [[[self class] allocWithZone: zone] init];
  copy.identifier = self.identifier;
  copy.accountType = self.accountType;
  copy.accountDescription = self.accountDescription;
  copy.username = self.username;
  copy.credential = self.credential;
  return copy;
}

-(NSString *)description; {
  NSString * identifier = self.identifier ? self.identifier : @"";
  SHAccountType * accountType = self.accountType;
  NSString * accountDescription = self.accountDescription ? self.accountDescription : @"";
  NSString * username = self.username ? self.username : @"";
  
  return @{ @"account.identifier" : identifier,
            @"account.accountType" : accountType,
            @"account.accountDescription" : accountDescription,
            @"account.username" : username
            }.description;
}


@end
