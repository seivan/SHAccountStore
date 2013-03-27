//
//  SHViewController.m
//  SHAccountStoreExample
//
//  Created by Seivan Heidari on 3/27/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHViewController.h"
#import "SHAccountStore.h"

@interface SHAccount ()
@property(nonatomic,readwrite) NSString * identifier;
@end

@interface SHViewController ()
-(void)showError:(NSError *)theError;
@end

@implementation SHViewController

-(void)viewDidAppear:(BOOL)animated; {
  [super viewDidAppear:animated];
  SHAccountStore        * accountStore      = [[SHAccountStore alloc] init];
  SHAccountType         * accountType       = [accountStore accountTypeWithAccountTypeIdentifier:@"LinkedInAccounts"];
  SHAccountCredential   * accountCredential = [[SHAccountCredential alloc]
                                               initWithOAuthToken:@"MyToken" tokenSecret:@"MySecret"];
  SHAccount             * account           = [[SHAccount alloc] initWithAccountType:accountType];
  account.credential = accountCredential;
  account.identifier = @"12312312";
  [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {

      if(granted)    [accountStore saveAccount:account withCompletionHandler:^(BOOL success, NSError *error) {
        if(success) dispatch_async(dispatch_get_main_queue(), ^{
          [[[UIAlertView alloc] initWithTitle:@"Success" message:account.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        });
        else [self showError:error];
      }];
      else [self showError:error];


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