//
//  SHAccountStore.m
//  SHAccountManagerExample
//
//  Created by Seivan Heidari on 3/20/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "UIAlertView+BlocksKit.h"

#import "LUKeychainAccess.h"

#import "SHAccountStore.h"

#import "SHAccountType.h"
#import "SHAccount.h"
#import "SHAccountCredential.h"
NSString * const SHAccountStoreDidChangeNotification = @"SHAccountStoreDidChangeNotification";

NSString * const kAccountTypeDicitonaryKey    = @"kAccountTypeDicitonaryKey";
NSString * const kAccountStoreDicitonaryKey   = @"kAccountStoreDicitonaryKey";

@protocol SHAccountTypePrivates <NSObject>
@optional
-(void)setAccountTypeDescription:(NSString *)accountTypeDescription;
-(void)setIdentifier:(NSString *)identifier;
-(void)setAccessGranted:(BOOL)accessGranted;


@end

@interface SHAccountType (Private)
<SHAccountTypePrivates>
-(id)initWithIdentifier:(NSString *)theIdentifier;

@end
@implementation SHAccountType (Private)

-(id)initWithIdentifier:(NSString *)theIdentifier; {
  self = [super init];
  if(self) {
    self.identifier = theIdentifier;
  }
  return self;
}



@end




@interface SHAccountStore ()

@end

@implementation SHAccountStore


-(SHAccount *)accountWithIdentifier:(NSString *)identifier; {
  NSAssert(identifier, @"Must pass identifier");
  __block SHAccount * chosenAccount = nil;
  LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
  NSDictionary * accountStoreDictionary = [keychain objectForKey:kAccountStoreDicitonaryKey];
  if(accountStoreDictionary == nil) accountStoreDictionary = @{};
  [accountStoreDictionary enumerateKeysAndObjectsUsingBlock:^(id _, NSSet * accountsSet, BOOL *stopDictionary) {
    [accountsSet enumerateObjectsUsingBlock:^(SHAccount * account, BOOL *stopSet) {
      if([account.identifier isEqualToString:identifier]) {
        chosenAccount = account;
        *stopDictionary = YES;
        *stopSet = YES;
      }
    }];
  }];
  
  return chosenAccount;
  
}

-(SHAccountType *)accountTypeWithAccountTypeIdentifier:(NSString *)typeIdentifier; {
  NSAssert(typeIdentifier, @"Must pass typeIdentifier");
  __block SHAccountType * accountTypeWithAccountTypeIdentifier = nil;
  LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
  NSDictionary * accountTypeDictionary = [keychain objectForKey:kAccountTypeDicitonaryKey];
  if(accountTypeDictionary == nil) accountTypeDictionary = @{};
  accountTypeWithAccountTypeIdentifier = accountTypeDictionary[typeIdentifier];
  
  if(accountTypeWithAccountTypeIdentifier == nil) {
    accountTypeWithAccountTypeIdentifier = [[SHAccountType alloc] initWithIdentifier:typeIdentifier];
  }
  
  return accountTypeWithAccountTypeIdentifier;
}


-(NSArray *)accountsWithAccountType:(SHAccountType *)accountType; {
  NSArray * accountsWithAccountType = nil;
  if(accountType.identifier != nil && accountType.accessGranted) {
    LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
    NSDictionary * accountStoreDictionary = [keychain objectForKey:kAccountStoreDicitonaryKey];
    if(accountStoreDictionary == nil) accountStoreDictionary = @{};
    NSSet * accountsSet = accountStoreDictionary[accountType.identifier];
    accountsWithAccountType = accountsSet.allObjects;
  }
  return accountsWithAccountType;
}

-(NSArray *)accounts; {
  NSMutableArray * accounts = @[].mutableCopy;
  LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
  NSDictionary * accountStoreDictionary = [keychain objectForKey:kAccountStoreDicitonaryKey];
  if(accountStoreDictionary == nil) accountStoreDictionary = @{};
  [accountStoreDictionary enumerateKeysAndObjectsUsingBlock:^(id _, NSSet * accountsSet, BOOL *__) {
    [accounts addObjectsFromArray:accountsSet.allObjects];
  }];
  return accounts.copy;
}

-(void)saveAccount:(SHAccount *)account withCompletionHandler:(SHAccountStoreSaveCompletionHandler)completionHandler; {
  NSError * error = nil;
  __block BOOL isSuccess = NO;
  @try {
    NSAssert(account, @"Must pass account");
    NSAssert(account.accountType, @"account must have accountType");
    
    LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
    NSDictionary * accountStoreDictionary = [keychain objectForKey:kAccountStoreDicitonaryKey];
    if(accountStoreDictionary == nil) accountStoreDictionary = @{};
    
    //Get two copies of accounts, mutable and immutable
    NSSet * accountsSet = accountStoreDictionary[account.accountType.identifier];
    if(accountsSet == nil) accountsSet = [NSSet set];
    NSMutableSet * accountsChangesSet = accountsSet.mutableCopy;
    
    //Remove existing account
    SHAccount * existingAccount = [self accountWithIdentifier:account.identifier];
    if(existingAccount) [accountsChangesSet removeObject:existingAccount];
    NSMutableDictionary * accountStoreChangeDictionary = accountStoreDictionary.mutableCopy;
    
    //Add new account
    [accountsChangesSet addObject:account.copy];
    
    //Sync back new sets of accounts back to the dictionary
    accountStoreChangeDictionary[account.accountType.identifier] = accountsChangesSet;
    
    [keychain setObject:accountStoreChangeDictionary forKey:kAccountStoreDicitonaryKey];
    isSuccess = YES;
    
    //Notify that changes have been made, and user should purge all accounts and accountTypes
    [NSNotificationCenter.defaultCenter postNotificationName:SHAccountStoreDidChangeNotification object:nil];
    
  }
  @catch (NSException *exception) {
    error = [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo];
  }
  @finally {
    completionHandler(isSuccess, error);
  }
  
}


-(void)requestAccessToAccountsWithType:(SHAccountType *)accountType
                 withCompletionHandler:(SHAccountStoreRequestAccessCompletionHandler)handler {
  [self requestAccessToAccountsWithType:accountType options:nil completion:handler];
}

-(void)requestAccessToAccountsWithType:(SHAccountType *)accountType
                               options:(NSDictionary *)options
                            completion:(SHAccountStoreRequestAccessCompletionHandler)completionHandler; {
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  __block NSError * error = nil;
  __block BOOL isSuccess = NO;
  @try {
    @try {
      NSAssert(accountType, @"Must pass accountType");
      //      NSAssert(accountType.accountTypeDescription, @"accountType must have accountTypeDescription");
    }
    @catch (NSException *exception) {[exception raise];}
    @finally {
      dispatch_semaphore_signal(semaphore);
    }
    
    
    NSString * appName  = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    NSString * alertMessage = [NSString stringWithFormat:@"%@ requests access to %@ accounts.", appName, accountType.identifier];
    NSString * alertTitle = [NSString stringWithFormat:@"Permission for %@", accountType.identifier];
    
    UIAlertView * alert = [UIAlertView alertViewWithTitle:alertTitle message:alertMessage];
    [alert addButtonWithTitle:@"Allow" handler:^{
      isSuccess = YES;
      LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
      NSDictionary * accountTypeDictionary = [keychain objectForKey:kAccountTypeDicitonaryKey];
      
      if(accountTypeDictionary == nil) accountTypeDictionary = @{};
      NSMutableDictionary * accountTypeChangesDictionary = accountTypeDictionary.mutableCopy;
      
      
      accountType.accessGranted = isSuccess;
      accountTypeChangesDictionary[accountType.identifier] = accountType;
      
      [keychain setObject:accountTypeChangesDictionary.copy forKey:kAccountTypeDicitonaryKey];
      
      [NSNotificationCenter.defaultCenter postNotificationName:SHAccountStoreDidChangeNotification object:nil];
      dispatch_semaphore_signal(semaphore);
    }];
    [alert addButtonWithTitle:@"Deny" handler:^{
      isSuccess = NO;
      @try {
        [NSException raise:NSGenericException format:@"Access denied"];
      }
      @catch (NSException *exception) {
        [exception raise];
      }
      @finally {
        dispatch_semaphore_signal(semaphore);
      }
      
    }];
    [alert show];
    
  }
  @catch (NSException *exception) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      error = [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo];
      dispatch_semaphore_signal(semaphore);
    });
  }
  @finally {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      
      completionHandler(isSuccess, error);
    });
  }
  
  
}

-(void)renewCredentialsForAccount:(SHAccount *)account completion:(SHAccountStoreCredentialRenewalHandler)completionHandler; {
  
}

-(void)removeAccount:(SHAccount *)account withCompletionHandler:(SHAccountStoreRemoveCompletionHandler)completionHandler; {
  
}

@end
