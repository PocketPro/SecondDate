//
//  SDMessage.m
//  seconddate
//
//  Created by Eytan Moudahi on 1/26/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import "SDMessage.h"

@implementation SDMessage

- (BOOL)sendMessage:(NSError **)error
{
    PFObject *object = [PFObject objectWithClassName:@"SDMessage"];
    
    // Safely set values. PFObject does not handle nil values well.
    for (NSString *key in @[@"body", @"senderUsername", @"recipientUsername"]) {
        if ([self valueForKeyPath:key]) {
            [object setObject:[self valueForKeyPath:key] forKey:key];
        }
    }
    
    BOOL saved = [object save:error];
    if (!saved) {
        NSLog(@"Error: %@", [*error localizedDescription]);
    }
    
    
    // Send the push notification from the app. This can be done by creating a query for installations with the receipients username. I added a username property to the current installation because I could not figure out how to query for the user directly.
    
    // It's may be more robust to send the push notification from the website.
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"username" equalTo:self.recipientUsername];
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:@"New Message!"];
    [push sendPushInBackground];
    
    return saved;
}

@end
