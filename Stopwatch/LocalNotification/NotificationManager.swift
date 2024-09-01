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
        let content = self.createContent(timeString: timeString)
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
        content.categoryIdentifier = "STOPWATCH_CATEGORY"
        return content
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleBackgroundWarningNotification() {
        let content = createNotificationContent(title: "Reminder", body: "The app has been in the background for 10 minutes. It will be dismissed soon.")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "BACKGROUND_WARNING_NOTIFICATION", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling background warning notification: \(error)")
            }
        }
    }
    
    func scheduleStopwatchStoppedNotification() {
        let content = createNotificationContent(title: "Stopwatch Timer Stopped", body: "The stopwatch timer has been stopped as the app was in the background for 15 minutes.")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "STOPWATCH_TIMER_STOPPED_NOTIFICATION", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling stopwatch stopped notification: \(error)")
            }
        }
    }
    
    private func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        return content
    }
    
    func setupNotificationActions() {
          
        let pauseAction = UNNotificationAction(identifier: "PAUSE_ACTION",
                                               title: "Pause",
                                               options: [.authenticationRequired])
        
        let resumeAction = UNNotificationAction(identifier: "RESUME_ACTION",
                                                title: "Resume",
                                                options: [.authenticationRequired])
        
        let resetAction = UNNotificationAction(identifier: "RESET_ACTION",
                                                title: "Reset",
                                                options: [.authenticationRequired])
        
        let category = UNNotificationCategory(identifier: "STOPWATCH_CATEGORY",
                                              actions: [pauseAction, resumeAction, resetAction],
                                                intentIdentifiers: [],
                                                options: [])
          
          UNUserNotificationCenter.current().setNotificationCategories([category])
      }
}
