import UIKit
import UserNotifications

final class NotificationManager {
    
    let userNotificationCenter: UNUserNotificationCenter
    let application: UIApplication
    var completion: ((Result<String, Error>) -> Void)? = nil
    
    init(userNotificationCenter: UNUserNotificationCenter, application: UIApplication) {
        self.userNotificationCenter = userNotificationCenter
        self.application = application
    }
    
    /// Requests notification permission and returns the device token if granted.
    func requestNotificationPermission(completion: @escaping (Result<String, Error>) -> Void) {
        
        self.completion = completion
        // Request permission for notifications
        userNotificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else {
                completion(.failure(NotificationError.permissionDenied))
                return
            }
            
            // Ensure the request was successful
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Register for remote notifications on the main thread
            DispatchQueue.main.async { [unowned self] in
                application.registerForRemoteNotifications()
            }
        }
    }

    // Custom error for notification-related issues
    enum NotificationError: Error, LocalizedError {
        case permissionDenied
        
        var errorDescription: String? {
            switch self {
            case .permissionDenied:
                return "Notification permission was denied."
            }
        }
    }
}

extension NotificationManager {
    /// Call this method from your AppDelegate's `didRegisterForRemoteNotificationsWithDeviceToken`.
    func didRegisterForRemoteNotifications(deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        completion?(.success(token))
    }
    
    /// Call this method from your AppDelegate's `didFailToRegisterForRemoteNotificationsWithError`.
    func didFailToRegisterForRemoteNotifications(error: Error) {
        completion?(.failure(error))
    }
}
