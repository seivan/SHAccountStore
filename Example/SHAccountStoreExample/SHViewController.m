//
//  SHViewController.m
//  SHAccountStoreExample
//
//  Created by Seivan Heidari on 3/27/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHViewController.h"
#import "SHAccountStore.h"
#import "UIActionSheet+BlocksKit.h"
#import "LUKeychainAccess.h"
@interface SHAccount ()
@property(nonatomic,readwrite) NSString * identifier;
@end

@interface SHViewController ()
-(void)showError:(NSError *)theError;
@end

@implementation SHViewController

-(void)viewDidAppear:(BOOL)animated; {
  [super viewDidAppear:animated];
//  LUKeychainAccess * keychain = [LUKeychainAccess standardKeychainAccess];
//  [keychain setObject:@{} forKey:@"kAccountStoreDicitonaryKey"];

  SHAccountStore        * accountStore      = [[SHAccountStore alloc] init];
  SHAccountType         * accountType       = [accountStore accountTypeWithAccountTypeIdentifier:@"LinkedInAccounts"];
  SHAccountCredential   * accountCredential = [[SHAccountCredential alloc]
                                               initWithOAuthToken:@"MyToken" tokenSecret:@"MySecret"];
  SHAccount             * account           = [[SHAccount alloc] initWithAccountType:accountType];
  account.credential = accountCredential;
  account.identifier = @"912312312";
  account.username  = @"theUsername";
  [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {

      if(granted)    [accountStore saveAccount:account withCompletionHandler:^(BOOL success, NSError *error) {
        if(success) dispatch_async(dispatch_get_main_queue(), ^{
          [[[UIAlertView alloc] initWithTitle:@"Success" message:account.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        });
        else [self showError:error];
      }];
      else [self showError:error];

    
    
    SHAccount * existingAccount = [accountStore accountWithIdentifier:account.identifier];
    NSLog(@"%@", existingAccount);
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      NSArray * accounts = accountStore.accounts;
      UIActionSheet * sheet = [UIActionSheet actionSheetWithTitle:@"Pick account"];
      [accounts enumerateObjectsUsingBlock:^(ACAccount * account, NSUInteger idx, BOOL *stop) {
        [sheet addButtonWithTitle:account.identifier handler:nil];
      }];
      [sheet setCancelButtonWithTitle:@"Cancel" handler:nil];
      [sheet showInView:self.view];
    });

  }];
  
  
}

-(void)showError:(NSError *)theError; {
  
  NSString * title   = theError.localizedDescription;
  NSString * message = theError.localizedRecoverySuggestion;
  NSLog(@"ERROR %@", theError.userInfo);
  NSLog(@"ERROR %@", theError.localizedDescription);
  NSLog(@"ERROR %@", theError.localizedFailureReason);
  NSLog(@"ERROR %@", theError.localizedRecoveryOptions);
  NSLog(@"ERROR %@", theError.localizedRecoverySuggestion);
  
  if(title == nil)   title   = @"Error";
  if(message == nil) message = @"Somethin' ain't right, son.";
  dispatch_async(dispatch_get_main_queue(), ^{
  [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
    });
}


@end