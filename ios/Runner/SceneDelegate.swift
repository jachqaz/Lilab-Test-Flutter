import Flutter
import UIKit
import UserNotifications

class SceneDelegate: FlutterSceneDelegate {
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        NSLog("🚀 SceneDelegate willConnectTo called")

        guard let windowScene = scene as? UIWindowScene,
              let window = windowScene.windows.first,
              let controller = window.rootViewController as? FlutterViewController
        else {
            NSLog("❌ Failed to get FlutterViewController")
            return
        }

        NativeServiceSetup.setUp(binaryMessenger: controller.binaryMessenger, api: NativeServiceImpl())
        NSLog("✅ Pigeon setup completed in SceneDelegate")
    }
}
