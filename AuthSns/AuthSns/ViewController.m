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

#import <TwitterKit/TwitterKit.h>

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
    
- (IBAction)touchedTwitterLoginButton:(UIButton *)sender
{
    [self doTwitterLogin];
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
        
        [self moveToDetailVCWithLogInType:LoginTypeFacebook];
        
    }];
}
    
- (void)doTwitterLogin
{
    //cache session 을 사용하지 않는 방법으로 로그인
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBasedForceLogin
                                    completion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        
                if(session)
                {
                    NSLog(@"Login session : %@", [session userName]);
        
                    self.userID = [session userID];
        
                    [self moveToDetailVCWithLogInType:LoginTypeTwitter];
                }
                else
                {
                    NSLog(@"Login Error : %@", error.description);
                }
        
    }];
}


- (void)moveToDetailVCWithLogInType:(LoginType)loginType
{
    UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-UserProfileVC"];
    
    userProfileVC.userId = self.userID;
    userProfileVC.loginType = loginType;
    
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

@end
