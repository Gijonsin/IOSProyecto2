//
//  AppDelegate.m
//  IOSProyecto2
//
//  Created by Guest User on 13/11/25.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Request notification permissions
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Notification permission granted");
            [self scheduleDailyReminders];
        }
    }];
    
    return YES;
}

- (void)scheduleDailyReminders {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // Remove existing notifications
    [center removeAllPendingNotificationRequests];
    
    // Morning reminder
    UNMutableNotificationContent *morningContent = [[UNMutableNotificationContent alloc] init];
    morningContent.title = @"🌍 EcoImpacto";
    morningContent.body = @"¡Buenos días! Recuerda registrar tus hábitos sostenibles de hoy.";
    morningContent.sound = [UNNotificationSound defaultSound];
    
    NSDateComponents *morningComponents = [[NSDateComponents alloc] init];
    morningComponents.hour = 9;
    morningComponents.minute = 0;
    
    UNCalendarNotificationTrigger *morningTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:morningComponents repeats:YES];
    UNNotificationRequest *morningRequest = [UNNotificationRequest requestWithIdentifier:@"DailyMorningReminder"
                                                                                 content:morningContent
                                                                                 trigger:morningTrigger];
    [center addNotificationRequest:morningRequest withCompletionHandler:nil];
    
    // Evening reminder
    UNMutableNotificationContent *eveningContent = [[UNMutableNotificationContent alloc] init];
    eveningContent.title = @"🌱 Revisión del Día";
    eveningContent.body = @"No olvides revisar tu impacto ambiental de hoy.";
    eveningContent.sound = [UNNotificationSound defaultSound];
    
    NSDateComponents *eveningComponents = [[NSDateComponents alloc] init];
    eveningComponents.hour = 20;
    eveningComponents.minute = 0;
    
    UNCalendarNotificationTrigger *eveningTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:eveningComponents repeats:YES];
    UNNotificationRequest *eveningRequest = [UNNotificationRequest requestWithIdentifier:@"DailyEveningReminder"
                                                                                 content:eveningContent
                                                                                 trigger:eveningTrigger];
    [center addNotificationRequest:eveningRequest withCompletionHandler:nil];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
