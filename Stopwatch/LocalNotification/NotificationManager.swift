import Foundation
import UserNotifications

class NotificationManager {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications")
            }
        }
    }
    
    func scheduleNotification(timeString: String) {
        let content = createContent(timeString: timeString)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
        
        let request = UNNotificationRequest(identifier: "STOPWATCH_NOTIFICATION", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification : \(error)")
            }
        }
    }
    
    private func createContent(timeString: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Stopwatch"
        content.body = "Current time: \(timeString)"
        content.sound = .default
        return content
    }
}
