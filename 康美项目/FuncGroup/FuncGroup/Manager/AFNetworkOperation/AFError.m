//
//  AFError.m
//  FuncGroup
//
//  Created by gary on 2017/2/15.
//  Copyright © 2017年 gary. All rights reserved.
//

#import "AFError.h"

NSString *const kAFErrorDomain = @"";

@implementation AFError

+ (NSString *)errorMessageForErrorType:(AFErrorType)errorType
{
    switch (errorType)
    {
        case AFUnknownErrorType:
            break;
        default:
            break;
    }
    return nil;
}

+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage
{
    return [[self alloc] initWithCode:errorType errorMessage:errorMessage subMessage:nil];
}

- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage subMessage:(NSString *)subMsg
{
    NSDictionary *info = nil;
    if (errorMessage && errorMessage.length > 0 && subMsg && subMsg.length > 0) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                [errorMessage description], NSLocalizedDescriptionKey,[subMsg description], NSLocalizedRecoverySuggestionErrorKey, nil];
    }else if (errorMessage && errorMessage.length > 0) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                [errorMessage description], NSLocalizedDescriptionKey, nil];
    }else if (subMsg && subMsg.length > 0) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                [subMsg description], NSLocalizedDescriptionKey, nil];
    }
    
    return [self initWithDomain:kAFErrorDomain
                           code:errorType
                       userInfo:(info)];
}

+ (id)errorWithError:(NSError *)error
{
    return [[self alloc] initWithCode:error.code errorMessage:[error localizedDescription] subMessage:[error localizedRecoverySuggestion]];
}

- (id)initWithError:(NSError *)error
{
    return [self initWithCode:error.code errorMessage:[error localizedDescription] subMessage:[error localizedRecoverySuggestion]];
}


@end
