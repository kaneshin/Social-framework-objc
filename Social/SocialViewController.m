//
//  SocialViewController.m
//  Social
//
//  Created by Shintaro Kaneko on 9/23/12.
//  Copyright (c) 2012 Shintaro Kaneko. All rights reserved.
//

#import "SocialViewController.h"

#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface SocialViewController ()

@end

@implementation SocialViewController
#define TWTWITTER @"TWTwitter"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGPoint center = CGPointMake(self.view.frame.size.width / 2.f, self.view.frame.size.height / 2.f);
    CGSize size = CGSizeMake(100.f, 50.f);
    UIButton *twitter = [[UIButton alloc] initWithFrame:CGRectMake(center.x - size.width / 2.f,
                                                                   center.y - 4 * size.height,
                                                                   size.width,
                                                                   size.height)];
    UIButton *facebook = [[UIButton alloc] initWithFrame:CGRectMake(center.x - size.width / 2.f,
                                                                   center.y - 2 * size.height,
                                                                   size.width,
                                                                   size.height)];
    UIButton *weibo = [[UIButton alloc] initWithFrame:CGRectMake(center.x - size.width / 2.f,
                                                                   center.y,
                                                                   size.width,
                                                                   size.height)];
    [twitter setTitle:@"Twitter" forState:UIControlStateNormal];
    [twitter setBackgroundColor:[UIColor blackColor]];
    [twitter addTarget:self action:@selector(postToTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [facebook setTitle:@"facebook" forState:UIControlStateNormal];
    [facebook setBackgroundColor:[UIColor blackColor]];
    [facebook addTarget:self action:@selector(postToFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [weibo setTitle:@"weibo" forState:UIControlStateNormal];
    [weibo setBackgroundColor:[UIColor blackColor]];
    [weibo addTarget:self action:@selector(postToWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitter];
    if(NSClassFromString(@"SLComposeViewController") != nil)
    {
        [self.view addSubview:facebook];
        [self.view addSubview:weibo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postToSocialService:(NSString *)socialServiceType initialText:(NSString *)socialText addImage:(UIImage *)socialImage addURLWithString:(NSString *)socialURLWithString
{
    if(NSClassFromString(@"SLComposeViewController") != nil)
    {
        if([SLComposeViewController isAvailableForServiceType:socialServiceType])
        {
            SLComposeViewController *socialController = [SLComposeViewController composeViewControllerForServiceType:socialServiceType];
            [socialController setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 [self dismissViewControllerAnimated:YES completion:nil];
                 NSString *message;
                 switch(result)
                 {
                     case SLComposeViewControllerResultCancelled:
                         message = NSLocalizedString(@"Cancelled", nil);
                         break;
                     case SLComposeViewControllerResultDone:
                         message = NSLocalizedString(@"Done", nil);
                         break;
                     default:
                         break;
                 }
                 NSLog(@"%@", message);
             }];
            [socialController setInitialText:socialText];
            [socialController addImage:socialImage];
            [socialController addURL:[NSURL URLWithString:socialURLWithString]];
            [self presentViewController:socialController animated:YES completion:nil];
        }
        else
        {
            NSString *title;
            if ([socialServiceType isEqualToString:SLServiceTypeTwitter])
                title = @"No Twitter Accounts";
            else if ([socialServiceType isEqualToString:SLServiceTypeFacebook])
                title = @"No Facebook Accounts";
            else if ([socialServiceType isEqualToString:SLServiceTypeSinaWeibo])
                title = @"No Weibo Accounts";
            NSString *message = @"There are no accounts configured. You can add or create an account in Settings.";
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if(NSClassFromString(@"TWTweetComposeViewController") != nil && TWTWITTER == socialServiceType)
    {
        TWTweetComposeViewController *twitterController = [[TWTweetComposeViewController alloc] init];
        [twitterController setCompletionHandler:^(TWTweetComposeViewControllerResult result)
         {
             [self dismissViewControllerAnimated:YES completion:nil];
             NSString *message;
             switch(result)
             {
                 case SLComposeViewControllerResultCancelled:
                     message = NSLocalizedString(@"Cancelled", nil);
                     break;
                 case SLComposeViewControllerResultDone:
                     message = NSLocalizedString(@"Done", nil);
                     break;
                 default:
                     break;
             }
             NSLog(@"%@", message);
         }];
        [twitterController setInitialText:socialText];
        [twitterController addImage:socialImage];
        [twitterController addURL:[NSURL URLWithString:socialURLWithString]];
        [self presentViewController:twitterController animated:YES completion:nil];
    }
}

- (void)postToTwitter:(id)sender
{
    NSString *twitterType;
    if(NSClassFromString(@"SLComposeViewController") != nil)
        twitterType = SLServiceTypeTwitter;
    else
        twitterType = TWTWITTER;
    [self postToSocialService:twitterType
                  initialText:@"Post to Twitter via iOS."
                     addImage:[UIImage imageNamed:@"House.jpg"]
             addURLWithString:@"https://twitter.com/"];
}

- (void)postToFacebook:(id)sender
{
    [self postToSocialService:SLServiceTypeFacebook
                  initialText:@"Post to Facebook via iOS."
                     addImage:[UIImage imageNamed:@"House.jpg"]
             addURLWithString:@"https://facebook.com/"];
}

- (void)postToWeibo:(id)sender
{
    [self postToSocialService:SLServiceTypeSinaWeibo
                  initialText:@"Post to Sina Weibo via iOS."
                     addImage:[UIImage imageNamed:@"House.jpg"]
             addURLWithString:@"http://weibo.com/"];
}

@end
