import SwiftUI
import Workflow
import WorkflowUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var notificationManager: NotificationManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let appDependencyContainer = AppDependencyContainer(application: .shared)
        notificationManager = appDependencyContainer.notificationManger
        
        let root = WorkflowHostingController(
            workflow: WelcomeWorkflow(dependencyContainer: appDependencyContainer)
        )
        root.view.backgroundColor = .systemBackground

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = root
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationManager.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        notificationManager.didFailToRegisterForRemoteNotifications(error: error)
    }
}
