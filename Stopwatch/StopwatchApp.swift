import SwiftUI
import UserNotifications

@main
struct StopwatchApp: App {
    let notificationManager = NotificationManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var viewModel: StopwatchViewModel
    
    init() {
        self.viewModel = StopwatchViewModel(notificationManager: notificationManager)
        self.notificationManager.requestNotificationPermission()
        self.notificationManager.setupNotificationActions()
        AppDelegate.stopwatchViewModel = self.viewModel
    }
    
    var body: some Scene {
        WindowGroup {
            StopwatchView(viewModel: viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    static var stopwatchViewModel: StopwatchViewModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
       
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "PAUSE_ACTION":
            AppDelegate.stopwatchViewModel?.stopTimer()
        case "RESUME_ACTION":
            AppDelegate.stopwatchViewModel?.startTimer()
        case "RESET_ACTION":
            AppDelegate.stopwatchViewModel?.resetTimer()
        default:
            break
        }
        completionHandler()
    }
}
