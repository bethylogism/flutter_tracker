import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let addAction = UNNotificationAction(
        identifier: "add_drink",
        title: "Add Drink",
        options: [.foreground]
    )
    let subtractAction = UNNotificationAction(
        identifier: "subtract_drink",
        title: "Subtract Drink",
        options: [.foreground]
    )
    let category = UNNotificationCategory(
        identifier: "drink_tracker_category",
        actions: [addAction, subtractAction],
        intentIdentifiers: [],
        options: []
    )
    UNUserNotificationCenter.current().setNotificationCategories([category])
    UNUserNotificationCenter.current().delegate = self

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Error requesting notification permissions: \(error)")
        }
        print("Notification permissions granted: \(granted)")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == "add_drink" {
            NotificationCenter.default.post(name: Notification.Name("AddDrink"), object: nil)
        } else if actionIdentifier == "subtract_drink" {
            NotificationCenter.default.post(name: Notification.Name("SubtractDrink"), object: nil)
        }
        completionHandler()
    }
}
