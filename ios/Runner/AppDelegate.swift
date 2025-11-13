import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configurar Firebase
    FirebaseApp.configure()
    
    // Registrar para notificaciones remotas
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Solicitar permisos de notificación
    application.registerForRemoteNotifications()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Este método se llama cuando se registra exitosamente para notificaciones remotas
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("📱 APNS Token registrado exitosamente")
    
    // Esto es importante para que Firebase pueda mapear el APNS token
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("🔑 APNS Token: \(token)")
    
    // Flutter Firebase Messaging manejará automáticamente este token
  }
  
  // Este método se llama si falla el registro de notificaciones remotas
  override func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("❌ Error al registrar APNS token: \(error.localizedDescription)")
  }
  
  // Manejar notificaciones cuando la app está en primer plano (iOS 10+)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("📲 Notificación recibida en primer plano")
    
    // Mostrar la notificación incluso cuando la app está abierta
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .sound, .badge]])
    } else {
      completionHandler([[.alert, .sound, .badge]])
    }
  }
  
  // Manejar cuando el usuario toca la notificación
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    print("👆 Usuario tocó la notificación")
    completionHandler()
  }
}
