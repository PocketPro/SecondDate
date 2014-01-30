//
//  SDChatViewController.h
//  seconddate
//
//  Created by Eytan Moudahi on 1/26/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMessagesTableViewController : PFQueryTableViewController

@property (strong, nonatomic) NSString *otherUsername;
@property (strong, nonatomic) NSString *currentUsername; 
- (void)sendMessageWithBody:(NSString*)body;
@end
