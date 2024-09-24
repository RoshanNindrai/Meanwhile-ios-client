import Foundation
import UIKit

struct AppDependencyContainer {
    let notificationManger: NotificationManager
    
    init(application: UIApplication, userNotificationCenter: UNUserNotificationCenter = .current()) {
        notificationManger = NotificationManager(userNotificationCenter: userNotificationCenter, application: application)
    }
}
