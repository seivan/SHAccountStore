//
//  SHAccount.h
//  SHAccountManagerExample
//
//  Created by Seivan Heidari on 3/20/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

//#import <Accounts/Accounts.h>

#import "SHAccountType.h"
#import "SHAccountCredential.h"
// The SHAccount class represents an account stored on the system.
// Accounts are created not bound to any store. Once an account is saved it belongs
// to the store it was saved into.

@interface SHAccount :  NSObject//ACAccount
<NSCoding>
// Creates a new account object with a specified account type.
-(id)initWithAccountType:(SHAccountType *)type;

// This identifier can be used to look up the account using [SHAccountStore accountWithIdentifier:].
@property(NS_NONATOMIC_IOSONLY,copy,readonly) NSString      * identifier;

// Accounts are stored with a particular account type. All available accounts of a particular type
// can be looked up using [SHAccountStore accountsWithAccountType:]. When creating new accounts
// this property is required.
@property(NS_NONATOMIC_IOSONLY,strong)   SHAccountType       * accountType;

// A human readable description of the account.
// This property is only available to applications that have been granted access to the account by the user.
@property(NS_NONATOMIC_IOSONLY,copy)     NSString            * accountDescription;

// The username for the account. This property can be set and saved during account creation. The username is
// only available to applications that have been granted access to the account by the user.
@property(NS_NONATOMIC_IOSONLY,copy)     NSString            * username;

// The credential for the account. This property can be set and saved during account creation. It is
// inaccessible once the account has been saved.
@property(NS_NONATOMIC_IOSONLY,strong)   SHAccountCredential * credential;

@end
