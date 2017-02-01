//
//  ViewController.m
//  AuthSns
//
//  Created by 김민아 on 2017. 2. 1..
//  Copyright © 2017년 김민아. All rights reserved.
//

#import "ViewController.h"
#import "UserProfileViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (strong, nonatomic) NSString *userID;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - User Action

- (IBAction)touchedLoginButton:(UIButton *)sender
{
    [self doFaceBookLogin];
}

#pragma mark - Private Method

- (void)doFaceBookLogin
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc]init];
    
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    
    NSArray *permissions = @[@"public_profile",@"email" ,@"user_friends", @"user_birthday"];
    
    [login logInWithReadPermissions:permissions fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        NSLog(@"login result : %@",result);
        
        NSLog(@"login error : %@", error);
        
        NSString *userId = result.token.userID;
        
        self.userID = userId;
        
        // email에 대한 권한을 받았는지 체크
        if([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"])
        {
            NSLog(@"email granted");
        }
        
        if([result.declinedPermissions containsObject:@"email"])
        {
            NSLog(@"email permission declined");
        }
        
        [self moveToDetailVC];
        
    }];
}

- (void)moveToDetailVC
{
    UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-UserProfileVC"];
    
    userProfileVC.userId = self.userID;
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

@end
