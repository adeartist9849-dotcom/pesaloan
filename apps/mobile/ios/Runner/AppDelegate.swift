import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let DEEP_LINK_SCHEME = "pesaloan"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure push notifications
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
                if let error = error {
                    print("Notification authorization error: \(error)")
                }
            }
        }
        
        application.registerForRemoteNotifications()
        
        // Handle deep links
        if let url = launchOptions?[.url] as? URL {
            handleDeepLink(url)
        }
        
        // Configure Flutter
        GeneratedPluginRegistrant.register(with: self)
        
        // Disable Flutter's default splash screen handling
        // We use native LaunchScreen.storyboard instead
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle universal links
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            return handleDeepLink(url)
        }
        return false
    }
    
    // Handle custom URL schemes
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return handleDeepLink(url)
    }
    
    private func handleDeepLink(_ url: URL) -> Bool {
        guard url.scheme == DEEP_LINK_SCHEME else { return false }
        
        // Forward to Flutter via method channel
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.pesaloan.app/deeplink", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onDeepLink", arguments: url.absoluteString)
        }
        
        return true
    }
    
    // Handle push notification registration
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(tokenString)")
        
        // Forward to Flutter
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.pesaloan.app/push", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onApnsToken", arguments: tokenString)
        }
    }
    
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
        print("Failed to register for remote notifications: \(error)")
    }
    
    // Handle notification when app is in foreground
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .badge, .sound])
    }
    
    // Handle notification tap
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle deep link from notification
        if let deepLink = userInfo["deep_link"] as? String,
           let url = URL(string: deepLink) {
            _ = handleDeepLink(url)
        }
        
        completionHandler()
    }
}