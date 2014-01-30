//
//  SDMessage.h
//  seconddate
//
//  Created by Eytan Moudahi on 1/26/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The SDMessage class is used to send messages to users.
 */
@interface SDMessage : NSObject

/*
 The body of the message. Right now, only text messages are supported.
 */
@property (strong, nonatomic) NSString *body;

/*
 The recipient and sender ids should not be device dependent. For example, choosing the installation id, or the device token is a bad idea. Creating a user account, and using the username is a much better id
 */
@property (strong, nonatomic) NSString *recipientUsername;
@property (strong, nonatomic) NSString *senderUsername;

- (BOOL)sendMessage:(NSError **)error;
@end
