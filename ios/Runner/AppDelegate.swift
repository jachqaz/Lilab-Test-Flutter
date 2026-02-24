import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NSLog("🚀 AppDelegate didFinishLaunchingWithOptions called")
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        GeneratedPluginRegistrant.register(with: self)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            NSLog("✅ Notification permission granted: \(granted)")
        }

        // Configurar Pigeon después de un pequeño delay para asegurar que el engine esté listo
        DispatchQueue.main.async {
            self.setupPigeon()
        }

        return result
    }

    private func setupPigeon() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            NSLog("⚠️ Window not ready, retrying...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupPigeon()
            }
            return
        }

        NativeServiceSetup.setUp(binaryMessenger: controller.binaryMessenger, api: NativeServiceImpl())
        NSLog("✅ Pigeon setup completed")
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("🔔 willPresent notification called: \(notification.request.content.title)")
        completionHandler([.alert, .sound, .badge])
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
        NSLog("📱 Sending notification: \(payload.titulo) - \(payload.mensaje)")
        
        let content = UNMutableNotificationContent()
        content.title = payload.titulo
        content.body = payload.mensaje
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                NSLog("❌ Error: \(error.localizedDescription)")
            } else {
                NSLog("✅ Notification added: \(payload.titulo)")
            }
        }
    }
}
