//
//  RNZendeskChat.m
//  Tasker
//
//  Created by Jean-Richard Lai on 11/23/15.
//  Copyright © 2015 Facebook. All rights reserved.
//

#import "RNZendeskChatModule.h"
#import <ChatSDK/ChatSDK.h>
#import <MessagingSDK/MessagingSDK.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>
#import <CommonUISDK/CommonUISDK.h>


@implementation RNZendeskChatModule

UIColor *navgiationBarColor;
UIColor *navigationBarTintColor;
UIColor *navgiationBarTitleColor;

+ (void) setNavigationBarBackground:(UIColor*)color tintColor:(UIColor*)tintColor titleColor:(UIColor*) titleColor {
    navgiationBarColor = color;
    navigationBarTintColor = tintColor;
    navgiationBarTitleColor = titleColor;
}

RCT_EXPORT_MODULE(RNZendeskChatModule);

RCT_EXPORT_METHOD(setVisitorInfo:(NSDictionary *)options) {
    ZDKChatAPIConfiguration *chatAPIConfiguration = [[ZDKChatAPIConfiguration alloc] init];
    NSString *name = @"";
    NSString *email = @"";
    NSString *phone = @"";
    if (options[@"name"]) {
      name = options[@"name"];
    }
    if (options[@"email"]) {
      email = options[@"email"];
    }
    if (options[@"phone"]) {
      phone = options[@"phone"];
    }
    chatAPIConfiguration.visitorInfo = [[ZDKVisitorInfo alloc] initWithName:name
                                                                       email:email
                                                                 phoneNumber:phone];
    
    if (options[@"tags"]) {
        chatAPIConfiguration.tags = options[@"tags"];
    }
    if (options[@"department"]) {
        chatAPIConfiguration.department = options[@"department"];
    }
    ZDKChat.instance.configuration = chatAPIConfiguration;
}

RCT_EXPORT_METHOD(startChat:(NSDictionary *)options) {
    [self setVisitorInfo:options[@"user"]];
    NSDictionary* uiSetting = options[@"uiSetting"];
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSArray *engines = @[
            (id) [ZDKChatEngine engineAndReturnError:&error]
        ];
        UIViewController *viewController = [ZDKMessaging.instance buildUIWithEngines:engines
                                                                             configs:@[]
                                                                               error:&error];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: uiSetting[@"iOSbackTitle"]
                                                                                           style: UIBarButtonItemStylePlain
                                                                                          target: self
                                                                                          action: @selector(dismiss)];
        
        UINavigationController *chatController = [[UINavigationController alloc] initWithRootViewController: viewController];
        chatController.navigationBar.tintColor = navigationBarTintColor;
        chatController.navigationBar.barTintColor = navgiationBarColor;
        chatController.navigationBar.translucent = false;
        NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:chatController.navigationBar.titleTextAttributes];
        [textAttributes setValue:navgiationBarTitleColor forKey:NSForegroundColorAttributeName];
        chatController.navigationBar.titleTextAttributes = textAttributes;
        
        [[self rootController] presentViewController:chatController animated:true completion:nil];
    });
}

- (UIViewController*) rootController{
    return [[UIApplication sharedApplication] windows][0].rootViewController;
}

- (void) dismiss {
    [[self rootController] dismissViewControllerAnimated:true completion:nil];
}

RCT_EXPORT_METHOD(init:(NSString *)accountKey) {
  [ZDKChat initializeWithAccountKey:accountKey queue:dispatch_get_main_queue()];
}

@end
