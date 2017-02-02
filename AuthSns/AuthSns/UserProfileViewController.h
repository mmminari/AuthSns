//
//  UserProfileViewController.h
//  SNSLogin
//
//  Created by 김민아 on 2017. 1. 25..
//  Copyright © 2017년 김민아. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginType) {
    LoginTypeFacebook = 0,
    LoginTypeTwitter,
};

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) NSString *userId;
@property (assign, nonatomic) LoginType loginType;

@end
