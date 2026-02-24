import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        guard let flutterEngine = engineBridge.flutterEngine else {
            return
        }
        NativeServiceSetup.setUp(binaryMessenger: flutterEngine.binaryMessenger, api: NativeServiceImpl())
    }
}

class NativeServiceImpl: NSObject, NativeService {
    func requestNotificationPermission() throws -> Bool {
        var granted = false
        let semaphore = DispatchSemaphore(value: 0)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            granted = success
            semaphore.signal()
        }

        semaphore.wait()
        return granted
    }
    
    func sendLocalNotification(payload: NotificationPayload) throws {
        let content = UNMutableNotificationContent()
        content.title = payload.titulo
        content.body = payload.mensaje
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: payload.id,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
}
