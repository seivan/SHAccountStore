//
//  SHAccountType.m
//  SHAccountManagerExample
//
//  Created by Seivan Heidari on 3/20/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAccountType.h"
@interface SHAccountType (Privates)

@end


@implementation SHAccountType
@synthesize accountTypeDescription = _accountTypeDescription;
@synthesize identifier = _identifier;
@synthesize accessGranted = _accessGranted;

-(void)setAccountTypeDescription:(NSString *)accountTypeDescription;{
  _accountTypeDescription = accountTypeDescription;
}


-(void)setIdentifier:(NSString *)identifier; {
  _identifier = identifier;
}

-(void)setAccessGranted:(BOOL)accessGranted; {
  _accessGranted = accessGranted;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.accountTypeDescription forKey:@"type.accountTypeDescription"];
  [coder encodeObject:self.identifier forKey:@"type.identifier"];
  [coder encodeBool:self.accessGranted forKey:@"type.accessGranted"];
}

-(id)initWithCoder:(NSCoder *)coder; {
  self = [super init];
  if(self) {
    self.accountTypeDescription = [coder decodeObjectForKey:@"type.accountTypeDescription"];
    self.identifier             = [coder decodeObjectForKey:@"type.identifier"];
    self.accessGranted          = [coder decodeBoolForKey:@"type.accessGranted"];

  }
  return self;
}

-(NSString *)accountTypeDescription; {
  if(_accountTypeDescription == nil)
    _accountTypeDescription = @"";
  return _accountTypeDescription;
}
//-(NSString *)description; {
//  NSString * accountTypeDescription = self.accountTypeDescription ?  self.accountTypeDescription : @"";
//  NSString * identifier = self.identifier ?  self.identifier : @"";
//  NSNumber * accessGranted = @(self.accessGranted);
//  
//  return @{ @"type.accountTypeDescription" : accountTypeDescription,
//            @"type.identifier" : identifier,
//            @"type.accessGranted" : accessGranted
//            }.description;
//}


@end
