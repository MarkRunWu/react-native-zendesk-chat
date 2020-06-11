#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface RNZendeskChatModule : NSObject<RCTBridgeModule>
+ (void) setNavigationBarBackground:(UIColor*)color tintColor:(UIColor*)tintColor titleColor:(UIColor*) titleColor;
@end
