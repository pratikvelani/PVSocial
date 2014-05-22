//
//  ViewController.m
//  Social
//
//  Created by Pratik Velani on 19/05/14.
//  Copyright (c) 2014 LionKing Media. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouched:(UIButton *)sender
{
    
    if ([PVSocialFacebook sharedSocial].hasActiveSession == YES)
    {
        //[[SocialFacebook sharedSocial] closeActiveSession];
        
        //[SocialFacebook sharedSocial]
        
        /*[[SocialFacebook sharedSocial] openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSLog(@"DONE");
        }];*/
    }
    else
    {
        [[PVSocialFacebook sharedSocial] openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSLog(@"DONE");
        }];
    }
}


@end
