//
//  SDChatViewController.m
//  seconddate
//
//  Created by Eytan Moudahi on 1/26/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import "SDChatViewController.h"
#import "SDMessage.h"

@interface SDChatViewController ()

@end

@implementation SDChatViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"Todo";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    // Construct a compound query for any message containing the current user. In an actual application, we'll be looking for messages between the recipient and the current user.
    PFQuery *queryRecipient = [PFQuery queryWithClassName:NSStringFromClass([SDMessage class])];
    [queryRecipient whereKey:@"recipientUsername" equalTo:[[PFUser currentUser] username]];
    [queryRecipient whereKey:@"senderUsername" equalTo:self.recipientUsername];
    
    PFQuery *querySender = [PFQuery queryWithClassName:NSStringFromClass([SDMessage class])];
    [querySender whereKey:@"recipientUsername" equalTo:self.recipientUsername];
    [querySender whereKey:@"senderUsername" equalTo:[[PFUser currentUser] username]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryRecipient,querySender]];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *messageIdentifier = @"messageIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"body"];
    return cell;
}

- (NSString*)recipientUsername
{
    if (!_recipientUsername) {
        // TODO: For testing purposes assume the recipient is the current user. Yes, we sending messages to ourself.
        _recipientUsername = [[PFUser currentUser] username];
    }
    return _recipientUsername;
}

- (IBAction)sendMessageButtonClicked:(id)sender {
    SDMessage *message = [[SDMessage alloc] init];
    message.body = @"It worked!";
    message.senderUsername = [[PFUser currentUser] username];
    message.recipientUsername = self.recipientUsername;
    
    NSError *error = nil;
    if ([message sendMessage:&error] == FALSE){
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadObjects];
}

@end
