//
//  SocialFacebook.h
//  Social
//
//  Created by Pratik Velani on 19/05/14.
//  Copyright (c) 2014 LionKing Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PVSocialFacebook : NSObject
{
    
}

@property (nonatomic, assign) BOOL hasActiveSession;
@property (nonatomic, weak) FBSession *activeSession;

+ (PVSocialFacebook *) sharedSocial;

- (BOOL) handleOpenURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication;
- (void) handleDidBecomeActive;

- (void) checkSession;

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void) openActiveSessionWithReadPermissions: (NSArray *) permissions allowLoginUI: (BOOL) allowLoginUI completionHandler: (FBSessionStateHandler)completionHandler;
- (void) closeActiveSession;
@end
