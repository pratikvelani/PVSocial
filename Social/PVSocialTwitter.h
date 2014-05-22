//
//  SocialTwitter.h
//  Social
//
//  Created by Pratik Velani on 19/05/14.
//  Copyright (c) 2014 LionKing Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFOAuth1Client.h"
#import "AFJSONRequestOperation.h"

@interface PVSocialTwitter : NSObject
{
    
}

typedef void (^TwitterSessionSuccessHandler)(AFOAuth1Token *accessToken, id responseObject);
typedef void (^TwitterSessionFailureHandler)(NSError *error);

typedef void (^TwitterRequestSuccessHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^TwitterRequestFailureHandler)(AFHTTPRequestOperation *operation, NSError *error);


@property (nonatomic, assign) BOOL hasActiveSession;
@property (strong, nonatomic) AFOAuth1Client *twitterClient;

+ (PVSocialTwitter *) sharedSocial;

- (void) openActiveSessionWithSuccess: (TwitterSessionSuccessHandler) success Failure: (TwitterSessionFailureHandler) failure;
- (void) closeActiveSession;
- (void) updateStatus:(NSString *)status success:(TwitterRequestSuccessHandler) success Failure: (TwitterRequestFailureHandler) failure;
- (void) updateStatus:(NSString *)status Media: (NSData *)media mediaName:(NSString *) mediaName mimeType: (NSString *) mimeType success:(TwitterRequestSuccessHandler) success Failure: (TwitterRequestFailureHandler) failure;

@end
