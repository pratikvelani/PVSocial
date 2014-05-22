//
//  SocialFacebook.m
//  Social
//
//  Created by Pratik Velani on 19/05/14.
//  Copyright (c) 2014 LionKing Media. All rights reserved.
//

#import "PVSocialFacebook.h"

@implementation PVSocialFacebook

+ (PVSocialFacebook *)sharedSocial {
    static PVSocialFacebook *sharedSocial = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSocial = [[self alloc] init];
    });
    return sharedSocial;
}

- (id)init {
    if (self = [super init]) {
        //someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void) checkSession
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [self openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:NO completionHandler:nil];
    }
}

- (BOOL)handleOpenURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void) handleDidBecomeActive
{
    [FBAppCall handleDidBecomeActive];
}


// Facebook
- (void) openActiveSessionWithReadPermissions: (NSArray *) permissions allowLoginUI: (BOOL) allowLoginUI completionHandler: (FBSessionStateHandler)completionHandler
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         PVSocialFacebook* socialFB = [PVSocialFacebook sharedSocial];
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [socialFB sessionStateChanged:session state:state error:error];
     }];
    
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
        
        if (completionHandler != nil)
        {
            completionHandler (session, state, error);
        }
    }];
    
    /*
     [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
     allowLoginUI:NO
     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     // Handler for session state changes
     // This method will be called EACH time the session state changes,
     // also for intermediate states and NOT just when the session open
     [self sessionStateChanged:session state:state error:error];
     }];
     
     */
}

- (void) closeActiveSession
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    _hasActiveSession = NO;
}

// This method will handle ALL the session state changes in the app
- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        
        _hasActiveSession = YES;
        _activeSession = session;
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
        
        _hasActiveSession = NO;
        _activeSession = nil;
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        
        _hasActiveSession = NO;
    }
}



@end
