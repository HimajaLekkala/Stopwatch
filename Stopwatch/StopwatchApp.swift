import SwiftUI
import UserNotifications

@main
struct StopwatchApp: App {
    let notificationManager = NotificationManager()
    
    init() {
        notificationManager.requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            StopwatchView(viewModel: StopwatchViewModel(notificationManager: notificationManager))
        }
    }
}
