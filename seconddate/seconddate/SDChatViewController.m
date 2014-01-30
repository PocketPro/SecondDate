//
//  SDChatViewController.m
//  seconddate
//
//  Created by Eytan Moudahi on 1/29/2014.
//  Copyright (c) 2014 WTLP. All rights reserved.
//

#import "SDChatViewController.h"
#import "SDMessagesTableViewController.h"

@interface SDChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *messageControlView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageControlViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageControlViewBottomConstraint;
@property (weak, nonatomic) SDMessagesTableViewController *messagesViewController;
@end

@implementation SDChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedSegue"]) {
        self.messagesViewController = segue.destinationViewController;
        self.messagesViewController.otherUsername = [[PFUser currentUser] username];
        self.messagesViewController.currentUsername = [[PFUser currentUser] username];
    }
}

- (IBAction)sendButtonClicked:(id)sender {
    [self.messagesViewController sendMessageWithBody:self.messageTextField.text];
}

/*
// Each notification includes a nil object and a userInfo dictionary containing the
// begining and ending keyboard frame in screen coordinates. Use the various UIView and
// UIWindow convertRect facilities to get the frame in the desired coordinate system.
// Animation key/value pairs are only available for the "will" family of notification.
UIKIT_EXTERN NSString *const UIKeyboardWillShowNotification;
UIKIT_EXTERN NSString *const UIKeyboardDidShowNotification;
UIKIT_EXTERN NSString *const UIKeyboardWillHideNotification;
UIKIT_EXTERN NSString *const UIKeyboardDidHideNotification;

UIKIT_EXTERN NSString *const UIKeyboardFrameBeginUserInfoKey        NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
UIKIT_EXTERN NSString *const UIKeyboardFrameEndUserInfoKey          NS_AVAILABLE_IOS(3_2); // NSValue of CGRect
UIKIT_EXTERN NSString *const UIKeyboardAnimationDurationUserInfoKey NS_AVAILABLE_IOS(3_0); // NSNumber of double
UIKIT_EXTERN NSString *const UIKeyboardAnimationCurveUserInfoKey    NS_AVAILABLE_IOS(3_0); // NSNumber of NSUInteger (UIViewAnimationCurve)

// Like the standard keyboard notifications above, these additional notifications include
// a nil object and begin/end frames of the keyboard in screen coordinates in the userInfo dictionary.
UIKIT_EXTERN NSString *const UIKeyboardWillChangeFrameNotification  NS_AVAILABLE_IOS(5_0);
UIKIT_EXTERN NSString *const UIKeyboardDidChangeFrameNotification   NS_AVAILABLE_IOS(5_0);

// These keys are superseded by UIKeyboardFrameBeginUserInfoKey and UIKeyboardFrameEndUserInfoKey.
UIKIT_EXTERN NSString *const UIKeyboardCenterBeginUserInfoKey   NS_DEPRECATED_IOS(2_0, 3_2);
UIKIT_EXTERN NSString *const UIKeyboardCenterEndUserInfoKey     NS_DEPRECATED_IOS(2_0, 3_2);
UIKIT_EXTERN NSString *const UIKeyboardBoundsUserInfoKey        NS_DEPRECATED_IOS(2_0, 3_2);
*/

- (void)keyboardWillShow:(NSNotification*)notification
{
    // Animate the control view
    
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Convert the animationCurve to the proper index into UIViewAnimationOptionCurve[type]
    UIViewAnimationOptions curveOption = (animationCurve - UIViewAnimationCurveEaseInOut) << 16;

    // Update the constraints
        self.messageControlViewBottomConstraint.constant = CGRectGetHeight(keyboardFrame);
    
    [UIView animateWithDuration:duration delay:0 options:curveOption animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardDidShow:(NSNotification*)notification
{
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve animationCurve = [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // Convert the animationCurve to the proper index into UIViewAnimationOptionCurve[type]
    UIViewAnimationOptions curveOption = (animationCurve - UIViewAnimationCurveEaseInOut) << 16;
    
    // Update the constraints
    self.messageControlViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:duration delay:0 options:curveOption animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHide:(NSNotification*)notification
{
    
}

@end
