import Foundation
import UserNotifications

class NotificationManager {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification: \(error)")
            } else if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleNotification(timeString: String) {
        let content = createContent(timeString: timeString)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "BACKGROUND_STOPWATCH_NOTIFICATION", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification : \(error)")
            } else {
                print("Scheduled Notification")
            }
        }
    }
    
    private func createContent(timeString: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Stopwatch"
        content.body = "Current time: \(timeString)"
        content.sound = .default
        content.categoryIdentifier = "SUBSEQUENT_NOTIFICATION_CATEGORY"
        return content
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
