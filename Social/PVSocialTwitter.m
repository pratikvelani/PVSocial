//
//  SocialTwitter.m
//  Social
//
//  Created by Pratik Velani on 19/05/14.
//  Copyright (c) 2014 LionKing Media. All rights reserved.
//

#import "PVSocialTwitter.h"

@implementation PVSocialTwitter
{
    
}

+ (PVSocialTwitter *)sharedSocial
{
    static PVSocialTwitter *sharedSocial = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSocial = [[self alloc] init];
    });
    return sharedSocial;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _twitterClient = [[AFOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"] key:@"6VRnUd2UIyHC8iWJqxQRvFPwl" secret:@"fMziDbFRkOgKGm2BvfKRv4QAq6NOFBcXLZR4WmA9ZAONbmSIYz"];
    }
    
    return  self;
}

- (void) openActiveSessionWithSuccess: (TwitterSessionSuccessHandler) success Failure: (TwitterSessionFailureHandler) failure
{
    [_twitterClient authorizeUsingOAuthWithRequestTokenPath:@"/oauth/request_token" userAuthorizationPath:@"/oauth/authorize" callbackURL:[NSURL URLWithString:@"gaviscon://twitter_success"] accessTokenPath:@"/oauth/access_token" accessMethod:@"POST" scope:nil success:^(AFOAuth1Token *accessToken, id responseObject) {
        [_twitterClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        if (success != nil)
        {
            success (accessToken, responseObject);
        }
        
        _hasActiveSession = YES;
        
    } failure:^(NSError *error) {
        
        if (failure != nil)
        {
            failure (error);
        }
        
        _hasActiveSession = NO;
    }];
}

- (void) closeActiveSession
{
    _hasActiveSession = YES;
}

- (void) updateStatus:(NSString *)status success:(TwitterRequestSuccessHandler) success Failure: (TwitterRequestFailureHandler) failure
{
    NSURLRequest *req = [_twitterClient requestWithMethod:@"POST" path:@"statuses/update.json" parameters:@{@"status":status}];
    
    AFHTTPRequestOperation *operation = [_twitterClient HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             if (success)
                                             {
                                                 success (operation, responseObject);
                                             }
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             if (failure)
                                             {
                                                 failure (operation, error);
                                             }
                                         }];
    
    [_twitterClient enqueueHTTPRequestOperation:operation];
}

- (void) updateStatus:(NSString *)status Media: (NSData *)media mediaName:(NSString *) mediaName mimeType: (NSString *) mimeType success:(TwitterRequestSuccessHandler) success Failure: (TwitterRequestFailureHandler) failure
{
    NSURLRequest *req = [_twitterClient multipartFormRequestWithMethod:@"POST"
                        path:@"statuses/update_with_media.json" parameters:@{@"status":status} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            [formData appendPartWithFileData:media name:@"media[]" fileName:mediaName mimeType:mimeType];
                            
                            dispatch_async( dispatch_get_main_queue(), ^{
                                
                                AFHTTPRequestOperation *operation = [_twitterClient HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                                     {
                                                                         //NSLog(@"responseObject : %@", responseObject);
                                                                         if (success != nil)
                                                                         {
                                                                             success(operation, responseObject);
                                                                         }
                                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                                     {
                                                                         //NSLog(@"Error: %@", error);
                                                                         
                                                                         if (failure)
                                                                         {
                                                                             failure (operation, error);
                                                                         }
                                                                     }];
                                [_twitterClient enqueueHTTPRequestOperation:operation];
                                
                            });
                                                 }];
}

/*- (void) sendMultipartFormRequest: (NSURLRequest *)request
{
    AFHTTPRequestOperation *operation = [_twitterClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             //NSLog(@"responseObject : %@", responseObject);
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             //NSLog(@"Error: %@", error);
                                         }];
    
    [_twitterClient enqueueHTTPRequestOperation:operation];
}*/

@end
