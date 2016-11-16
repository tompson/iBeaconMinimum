

import UIKit
import UserNotifications
import Fabric
import Crashlytics
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureLogger()
        DDLogInfo("didFinishLaunchingWithOptions")
        Fabric.with([Crashlytics.self])

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { (granted, error) in
            DDLogInfo("UNUserNotificationCenter.requestAuthorization \(granted)")
        })
        return true
    }
    
    func configureLogger() {
//        #if DEBUG
            DDLog.add(DDTTYLogger.sharedInstance()) // TTY = Xcode console
//        #else
            DDLog.add(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
            let fileLogger: DDFileLogger = DDFileLogger() // File Logger
            DDLog.add(fileLogger)
//        #endif
    }

    func applicationWillResignActive(_ application: UIApplication) {
        DDLogInfo("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DDLogInfo("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DDLogInfo("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DDLogInfo("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("applicationWillTerminate")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let alert = UIAlertController.init(title: "\(notification.request.content.title)", message: "\(notification.request.content.body)", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

