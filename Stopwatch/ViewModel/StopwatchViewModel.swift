import Foundation
import UIKit

enum StopwatchToggleType: String, CaseIterable, Identifiable {
    case seconds = "Seconds"
    case milliSeconds = "Milliseconds"
    
    var id: String {
        return self.rawValue
    }
    
    var timeFormat: String {
        switch self {
        case .seconds:
            return "00:00:00"
        case .milliSeconds:
            return "00:00:00:00"
        }
    }
    
    var format: String {
        switch self {
        case .seconds:
            return "%02d:%02d:%02d"
        case .milliSeconds:
            return "%02d:%02d:%02d.%d"
        }
    }
    
    var timeInterval: Double {
        switch self {
        case .seconds:
            return 1
        case .milliSeconds:
            return 0.1
        }
    }
}

class StopwatchViewModel: ObservableObject {
    @Published var selectedStopwatchToggle: StopwatchToggleType = .seconds
    @Published var timeString: String = "00:00:00"
    @Published var isTimeRunning: Bool = false
    private var timer: Timer?
    private var startTime: Date?
    var elapsedTime: TimeInterval = 0
    var notificationmanager: NotificationManager
    private var backgroundStartDate: Date?
    private var backgroundTrackingTimer: Timer?
    
    init(notificationManager: NotificationManager) {
        self.notificationmanager = notificationManager
    }
    
    func startTimer() {
        guard timer == nil else { return }
        self.startTime = Date()
        self.timer = Timer.scheduledTimer(withTimeInterval: selectedStopwatchToggle.timeInterval, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
        self.isTimeRunning = true
    }
    
    private func updateTime() {
        guard let startTime = startTime else { return }
        let now = Date()
        let totalElapsed = elapsedTime + now.timeIntervalSince(startTime)
        
        let hours = Int(totalElapsed) / 3600
        let minutes = (Int(totalElapsed) % 3600) / 60
        let seconds = Int(totalElapsed) % 60
        let milliSeconds = Int(totalElapsed * 10) % 10
        
        self.timeString = String(format: selectedStopwatchToggle.format, hours, minutes, seconds, milliSeconds)
    }

    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        if let startTime = startTime {
            self.elapsedTime += Date().timeIntervalSince(startTime)
        }
        self.isTimeRunning = false
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.elapsedTime = 0
        self.timeString = selectedStopwatchToggle.timeFormat
        self.startTime = nil
        self.isTimeRunning = false
    }
}

extension StopwatchViewModel {
    func appDidEnterBackground() {
        guard self.timeString != self.selectedStopwatchToggle.timeFormat else { return }
        self.backgroundStartDate = Date()
        self.backgroundTrackingTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkBackgroundTime()
        }
        self.notificationmanager.scheduleNotification(timeString: timeString, isTimeRunning: self.isTimeRunning)
    }
    
    func appWillEnterForeground() {
        self.notificationmanager.removeAllNotifications()
    }
    
    func appWillTerminate() {
        self.notificationmanager.removeAllNotifications()
    }
    
    private func checkBackgroundTime() {
        guard let startDate = backgroundStartDate else { return }
        let elapsedTime = Date().timeIntervalSince(startDate)
        
        if elapsedTime >= 900 {
            self.resetTimer()
            self.notificationmanager.scheduleStopwatchStoppedNotification()
        } else if elapsedTime >= 600 {
            notificationmanager.scheduleBackgroundWarningNotification()
        }
    }
}
