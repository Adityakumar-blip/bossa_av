import UIKit
import Flutter
//import FBSDKCoreKit
// import background_locator

// func registerPlugins(registry: FlutterPluginRegistry) -> () {
//     if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
//         GeneratedPluginRegistrant.register(with: registry)
//     } 
// }

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
//     if #available(iOS 13.0, *) {
//       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//     }

//     ApplicationDelegate.shared.application(
//         application,
//         didFinishLaunchingWithOptions: launchOptions
//     )

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
// func application(
//         _ app: UIApplication,
//         open url: URL,
//         options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//     ) -> Bool {

//         ApplicationDelegate.shared.application(
//             app,
//             open: url,
//             sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//             annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//         )
//     }

// }
